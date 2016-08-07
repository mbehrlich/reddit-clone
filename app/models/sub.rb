class Sub < ActiveRecord::Base



  validates :title, :moderator_id, presence: true
  validates :title, uniqueness: true

  belongs_to :moderator,
    primary_key: :id,
    foreign_key: :moderator_id,
    class_name: :User

  has_many :post_subs,
    dependent: :destroy

  has_many :posts,
    through: :post_subs,
    source: :post



end
