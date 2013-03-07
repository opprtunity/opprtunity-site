class User < ActiveRecord::Base
  include RocketPants::Cacheable

  attr_accessible :about, :company_name, :company_url, :email, :first_name, 
                  :google_plus, :last_name, :linked_in, :phone, :skype, :zip_code,
                  :provider, :uid, :offerings, :needs

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

  def upcoming_meetings
    meetings.upcoming.all
  end

  def past_meetings
    meetings.past.all
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
      user.save!
    end
  end

  after_validation :assign_lat_long

  def matching_users_old
    # this still has a _lot_ of room for improvement
    # I think this can be reduced to a single SQL query but my SQL-FU
    # is not yet at that level :(

    needs.map do |n|
      ::User.joins(:offerings)
        .where('offerings.name' => n.name)
        .where("users.id != #{self.id}")
        .near([self.latitude, self.longitude], NEARBY_THRESHOLD)
    end.flatten
  end


  def matching_users

    @offerings = @user.offerings.map{|i| i.name}.flatten

    @needs = @user.needs.map{|i| i.name}.flatten

    # find other users
    # - who needs this user's offers or who offers this user's needs
    # - and are within certain radius
    @matching_users = User.uniq
      .joins(:needs)
      .joins(:offerings)
      .where("needs.name IN (:offerings) OR offerings.name In (:needs)", :offerings => @offerings, :needs => @needs)
      .where("users.id != ?", self.id)
      .near([self.latitude, self.longitude], NEARBY_THRESHOLD)
  end  

  private

  def assign_lat_long
    (self.latitude, self.longitude) = self.zip_code.to_latlon.split(',').map{ |c| c.strip.to_f } unless(self.zip_code.blank? || !self.zip_code.to_latlon)
  end
end
