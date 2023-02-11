module Api
  module V1
    class VotesController < ApplicationController
      before_action :set_votable
      before_action :authenticate

      def create
        # If upvote set value to 1, otherwise set the value to -1 for downvote
        vote_type = params.key?(:upvote) ? 1 : -1

        # Find or initialize vote from votable belonging to current account
        @vote = @votable.votes.find_or_initialize_by(account_id: current_account.id)

        # Save changes and render resource or errors
        if @vote.update_attribute(:vote_type, vote_type)
          render_resource(@vote)
        else
          unprocessable_entity(@vote)
        end
      end

      def destroy
        @vote = @current_account.votes.where(votable: @votable)
        return not_found unless @vote

        if @vote.destroy_all
          head :no_content
        else
          unprocessable_entity(@vote)
        end
      end

      private

      def set_votable
        @votable = params[:post_id] ? Post.find(params[:post_id]) : Comment.find(params[:comment_id])
      end
    end
  end
end
