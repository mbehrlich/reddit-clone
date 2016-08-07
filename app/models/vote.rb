class Vote < ActiveRecord::Base

  validates :user_id, :votable_id, :votable_type, presence: true
  validates :value, inclusion: { in: [1, -1] }

  belongs_to :votable, polymorphic: true
end
