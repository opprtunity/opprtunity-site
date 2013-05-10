namespace :usr do
  desc 'List users who have selected too much offers or needs.'
  task :list_offer_need_users => [:environment] do

    User.all.each do |user|
      if user.needs.length > 5 or user.offerings.length > 5

        puts user.first_name
        puts user.last_name
        puts user.email

        user.needs.each { |need|  print "#{need.name.to_s}, " }
        print "\n"
        user.offerings.each { |offer|  print "#{offer.name.to_s}, " }
        puts "\n------------"
      end
    end
  end
end
