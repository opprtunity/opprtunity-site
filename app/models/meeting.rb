class Meeting < ActiveRecord::Base
  attr_accessible :date, :medium, :rating

  has_one :partner, class_name: 'User'
  belongs_to :user

  def self.upcoming
    where ['created_at > ?', Time.now]
  end

  def self.past
    where ['created_at <= ?', Time.now]
  end
end
