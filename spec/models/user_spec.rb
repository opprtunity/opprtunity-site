require 'spec_helper'

describe User do
  before :all do
    @mike = FactoryGirl.create :user_mike_jones
    @sally = FactoryGirl.create :user_sally_smith
    @bob = FactoryGirl.create :user_bob_poole
  end
  
  it 'passes a sanity check' do
    @bob.first_name.should  eql('Bob')
    @bob.matches.map(&:id).should include(@mike.id, @sally.id)
  end

  describe 'validations' do
    context 'malformed email addresses' do
      it 'disallows no tld' do
        lambda { FactoryGirl.create :user, email: 'no@tld' }.should raise_error(ActiveRecord::RecordInvalid)
      end

      it 'disallows no @' do
        lambda { FactoryGirl.create :user, email: 'no-at-tld.com' }.should raise_error(ActiveRecord::RecordInvalid)
      end

      it 'disallows no username' do
        lambda { FactoryGirl.create :user, email: '@nousername.com' }.should raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'malformed urls' do
      it 'disallows no schema' do
        lambda { FactoryGirl.create :user, company_url: 'google.com' }.should raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'matching engine' do
    before :all do
      @tim_jones = FactoryGirl.create :user_tim_jones
      @bill_smith = FactoryGirl.create :user_bill_smith
    end
    it 'finds matching users' do
      @tim_jones.matching_users.should include(@bill_smith)
    end
    it 'updates the matches table with the matches'
    it 'notifies both users with the correct info'
  end
end

# Tim Jones lives in Detroit, MI 
# and is a Web Designer 
# who needs an Attorney 
# who likes to communicate via Skype and Google+.  

# Bill Smith lives in Dearborn, MI
# is an Attorney 
# who needs a Web Designer
# who likes to communicate via Skype Only.

# Because they both need each other...
# and they reside within 90 miles of each other...
# A match is generated
# with an email telling them both
# they should connect via Skype since they have this is common.
# Email and phone are always present as well.

# The email to both people should look something like the following.
# Of course the email to Bill will contain Tim's info and the email to Tim will contain Bill's info:
 
# Hey Tim,
 
# We've found you an incredible opportunity to do business!
 
# Bill Jones is an attorney in Dearborn, MI looking for a web designer... AND you're a web designer looking for an attorney.  
 
# Here are a few ways you can contact Bill:
 
# Contact Bill using Skype:   billjones1
# Contact Bill using Email:   billjones@gmail.com
# Contact Bill using Phone:   111-730-1793

