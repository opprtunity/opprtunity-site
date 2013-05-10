class User < ActiveRecord::Base
  include RocketPants::Cacheable

  attr_accessible :about, :company_name, :company_url, :email, :first_name,
                  :google_plus, :last_name, :linked_in, :phone, :skype, :zip_code,
                  :provider, :uid, :offerings, :needs, :user_slug

  reverse_geocoded_by :latitude, :longitude
  #  after_validation :reverse_geocode  # auto-fetch address

  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  URL_REGEXP = URI::regexp(%w(http https))

  validates :email, :format => { :with => EMAIL_REGEXP, :on => :create }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :linked_in, :format => { :with => URL_REGEXP }

  has_and_belongs_to_many :needs
  has_and_belongs_to_many :offerings
  has_many :meetings
  has_many :matches

  after_validation :assign_lat_long

  def upcoming_meetings
    meetings.upcoming.all
  end

  def past_meetings
    meetings.past.all
  end

  def needs_list
    needs.map(&:name).join(', ')
  end

  def offerings_list
    offerings.map(&:name).join(', ')
  end

  def matching_users

    @offerings = self.offerings.map{|i| i.name}.flatten

    @needs = self.needs.map{|i| i.name}.flatten

    # find other users
    # - who needs this user's offerings or who offers this user's needs
    # - and are within certain radius
    @matching_users = User.uniq
      .joins(:needs)
      .joins(:offerings)
      .where("needs.name IN (:offerings) OR offerings.name In (:needs)", :offerings => @offerings, :needs => @needs)
      .where("users.id != ?", self.id)
      .near([self.latitude, self.longitude], NEARBY_THRESHOLD)
  end

  def self.create_from_auth_hash(auth_hash, ip)
    where(auth_hash.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth_hash['provider']
      user.uid = auth_hash['uid']
      user.email = auth_hash['info']['email']
      user.linked_in = auth_hash['info']['urls']['public_profile']
      user.first_name = auth_hash['info']['first_name']
      user.last_name = auth_hash['info']['last_name']
      user.token = auth_hash['credentials']['token']
      user.secret = auth_hash['credentials']['secret']
      user.ip = ip
      # user.about = auth_hash['info']['headline']
      user.location = auth_hash['extra']['raw_info']['location']['name']
      user.image = auth_hash['info']['image']
      geo = Geocoder.search(ip).first
      user.zip_code ||= geo.data['zipcode'] if geo

      slug = ("#{user.first_name.downcase}-#{user.last_name.downcase}").gsub(" ", "-")
      user.user_slug = ActiveSupport::Inflector.transliterate(slug)
      user_slug_uniquess = User.where("user_slug LIKE :prefix", prefix: "#{slug}%").length
      user.user_slug += user_slug_uniquess.to_s if user_slug_uniquess > 0

      user.save!
    end
  end

  def self.update_match(source_id, target_id)

    Rails.logger.info "==== running update_match for #{source_id} and #{target_id}"

    source_user = User.find(source_id)
    target_user = User.find(target_id)

    # match_type -
    # match_type_reverse -

    match_type = "none"
    match_type_reverse = "none"

    # if source needs what target offers by name match
    matched_needs = []
    for n in source_user.needs
      for t_o in target_user.offerings
      matched_needs.push(n.name) if n.name == t_o.name
      end
    end
    Rails.logger.info  "======== matched_needs: #{matched_needs}"

    # if source offers what target needes by name match
    matched_offerings = []
    for o in source_user.offerings
      for t_n in target_user.needs
      matched_offerings.push(o.name) if o.name == t_n.name
      end
    end
    Rails.logger.info  "======== matched_offerings #{matched_offerings}"

    # if the source needs what the target offers, find the matches
    if matched_needs.length > 0
      needs_match = source_user.matches.find_or_initialize_by_target_id(target_id)
      # add a new record to the match table if it doesn't exist
      if needs_match.new_record?
        needs_match.save!
        match_type = "needs"
      end
    end

    # if the source needs what the target offers, find the matches
    if matched_offerings.length > 0
      offerings_match = target_user.matches.find_or_initialize_by_target_id(source_id)
      if offerings_match.new_record?
        offerings_match.save!
        # if the match is already on needs then it's reciprocal, else just offerings
        if match_type === "needs"
          match_type = "reciprocal"
        else
          match_type = "offerings"
        end
      end
    end
    Rails.logger.info  "========= match_type: #{match_type} "

    # used below
    match_type_reverse = "reciprocal" if match_type == "reciprocal"
    match_type_reverse = "needs" if match_type == "offerings"
    match_type_reverse = "offerings" if match_type == "needs"

    if match_type != "none" and match_type_reverse != "none"

      # send mail to source_user
      mail = MatchMailer.send_match(source_user, target_user, matched_needs, matched_offerings, match_type)
      Rails.logger.info  "========= source mail sent: #{mail}"

      # send mail to target_user
      mail = MatchMailer.send_match(target_user, source_user, matched_offerings, matched_needs, match_type_reverse)
      Rails.logger.info  "========= target mail sent: #{mail}"

    end

  end

  private

  def assign_lat_long
    (self.latitude, self.longitude) = self.zip_code.to_latlon.split(',').map{ |c| c.strip.to_f } unless(self.zip_code.blank? || !self.zip_code.to_latlon)
  end
end
