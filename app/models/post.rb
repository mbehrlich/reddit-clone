class Post < ActiveRecord::Base

  validates :title, :author_id, presence: true

  belongs_to :author,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :User

  has_many :post_subs,
    dependent: :destroy

  has_many :subs,
    through: :post_subs,
    source: :sub

  has_many :comments

  def comments_by_parent_id
    comments_hash = Hash.new { |h, k| h[k] = [] }
    self.comments.each do |comment|
      comments_hash[comment.parent_comment_id] << comment
    end
    comments_hash
  end

  has_many :votes, as: :votable


  def score
    vote_sum = 0
    self.votes.each do |vote|
      vote_sum += vote.value
    end
    vote_sum
  end


end
