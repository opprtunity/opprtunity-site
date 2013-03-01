FactoryGirl.define do
  factory :user do
    first_name 'Random'
    last_name  'User'
    about 'For all of those who were unable to view #DifferentSpokes this morning with special guest host Andy Piper, you can watch the recording now. It was a jam packed show with a lot of great questions, and good laughs as usual. Huge thanks to Andy for joining and we definitely hope to have him back on soon.'
    company_name 'Google Inc'
    company_url 'http://www.google.com'
    email 'bob@google.com'
    google_plus 'https://plus.google.com/u/2/110073524479362862551'
    linked_in 'http://www.linkedin.com/profile/view?id=39276603'
    phone '555-6474'
    skype 'bobpoole'
    zip_code '90210'
    registered true

    factory :user_mike_jones do
      first_name 'Mike'
      last_name 'Jones'
      zip_code '90210'
      needs {
        [
          get_need_named('IT Consulting'),
          get_need_named('Plumbing'),
          get_need_named('Handyman Work'),
        ]
      }
      offerings {
        [
          get_offering_named('Professional Writing'),
          get_offering_named('Scrapbook Services'),
        ]
      }
    end

    factory :user_sally_smith do
      first_name 'Sally'
      last_name 'Smith'
      zip_code '11111'
      needs {
        [
          get_need_named('IT Consulting'),
          get_need_named('Database Design'),
        ]
      }
      offerings {
        [
          get_offering_named('Lawn Services'),
          get_offering_named('Pool Maintenance'),
        ]
      }
    end

    factory :user_bob_poole, :parent => :user  do
      first_name 'Bob'
      last_name  'Poole'
      needs {
        [
          get_need_named('Designer'),
          get_need_named('Attorney'),
          get_need_named('Painter'),
          get_need_named('Accountant'),
          get_need_named('PR Firm')
        ]
      }
      offerings {
        [
          get_offering_named('Web Design'),
          get_offering_named('IT Consulting'),
          get_offering_named('DB Admin'),
        ]
      }
      meetings {
        [
          FactoryGirl.create(:meeting, date: Date.today, medium: 'Skype', partner: User.where(first_name: 'Bill', last_name: 'Julia').first),
          FactoryGirl.create(:meeting, date: Date.today, medium: 'Phone', partner: User.where(first_name: 'Janis', last_name: 'Krums').first),
          FactoryGirl.create(:meeting, date: Date.today, medium: 'Google+', partner: User.where(first_name: 'Jane', last_name: 'Diller').first),
          FactoryGirl.create(:meeting, date: Date.today, medium: 'Unknown', partner: User.where(first_name: 'Bill', last_name: 'James').first),
          FactoryGirl.create(:meeting, date: Date.today, medium: 'Unknown', partner: User.where(first_name: 'Steve', last_name: 'Jobs').first),
          FactoryGirl.create(:meeting, date: Date.today, medium: 'Unknown', partner: User.where(first_name: 'Barry', last_name: 'Bonds').first)
        ]
      }
      matches {
        [
          FactoryGirl.create(:match, target_id: get_user_named('Mike', 'Jones').id),
          FactoryGirl.create(:match, target_id: get_user_named('Sally', 'Smith').id)
        ]
      }
    end

    factory :user_tim_jones, :parent => :user  do
      first_name 'Tim'
      last_name  'Jones'
      zip_code '48201'
      needs {
        [
          get_need_named('Attorney'),
        ]
      }
      offerings {
        [
          get_offering_named('Web Design'),
        ]
      }
    end

    factory :user_bill_smith, :parent => :user  do
      first_name 'Bill'
      last_name  'Smith'
      zip_code '48120'
      needs {
        [
          get_need_named('Web Design'),
        ]
      }
      offerings {
        [
          get_offering_named('Attorney'),
        ]
      }
    end

  end
end

def get_need_named(name)
  # get existing need or create new one
  Need.where(:name => name).first || FactoryGirl.create(:need, :name => name)
end

def get_offering_named(name)
  # get existing offering or create new one
  Offering.where(:name => name).first || FactoryGirl.create(:offering, :name => name)
end

def get_user_named(first, last)
  # get existing user or create new one
  User.where(first_name: first, last_name: last).first || FactoryGirl.create(:user, first_name: first, last_name: last)
end