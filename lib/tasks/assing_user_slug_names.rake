namespace :usr do
  desc 'Update exitsting users with a user_slug name'
  task :assign_slug_names => [:environment] do

    User.all.each do |user|
      user.user_slug = nil
      user.save!
    end

    User.all.each do |user|
      slug = ("#{user.first_name.downcase}-#{user.last_name.downcase}").gsub(" ", "-")
      user.user_slug = ActiveSupport::Inflector.transliterate(slug)

      user_slug_uniquess = User.where("user_slug LIKE :prefix", prefix: "#{slug}%").length
      user.user_slug += user_slug_uniquess if user_slug_uniquess > 0

      user.save!
    end
  end
end
