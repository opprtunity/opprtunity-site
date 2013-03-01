class Match < ActiveRecord::Base
  belongs_to :user
  attr_accessible :score, :target_id

  def target
    User.find(target_id)
  end

  def target=(user)
    target_id = user.id
    save!
  end

  def serializable_hash(options = {})
    super include: [:target]
  end
end
