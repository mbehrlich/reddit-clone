class VotesController < ApplicationController

  def upvote
    @vote = Vote.find_by(vote_params)
    
    if @vote.nil?
      Vote.create(value: 1, votable_id: vote_params[:votable_id], votable_type: vote_params[:votable_type], user_id: current_user.id)
    else
      @vote.update(value: 1)
    end
    redirect_to :back
  end

  def downvote
    @vote = Vote.find_by(vote_params)
    if @vote.nil?
      Vote.create(value: -1, votable_id: vote_params[:votable_id], votable_type: vote_params[:votable_type], user_id: current_user.id)
    else
      @vote.update(value: -1)
    end
    redirect_to :back
  end

  def vote_params
    params.require(:vote).permit(:votable_id, :votable_type)
  end

end
