class Comment < ActiveRecord::Base

  validates :content, :author_id, :post_id, presence: true

  belongs_to :post

  belongs_to :author,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :User

  belongs_to :parent,
    primary_key: :id,
    foreign_key: :parent_comment_id,
    class_name: :Comment

  has_many :children,
    primary_key: :id,
    foreign_key: :parent_comment_id,
    class_name: :Comment

  has_many :votes, as: :votable

end
