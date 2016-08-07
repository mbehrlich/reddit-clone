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

  def score
    vote_sum = 0
    self.votes.each do |vote|
      vote_sum += vote.value
    end
    vote_sum
  end

end
