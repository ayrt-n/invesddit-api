module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate, only: %i[create update]

      def index
        @comments = Post.find(params[:post_id]).comments.includes(:account)
        @comments = @comments.send("sort_by_#{sort_by_params}")

        # Get all votes by the current account for the comments queried
        @current_account_votes = Vote.for_votables_and_account(@comments, @current_account)

        # Group comments by reply_id to work with top-level and nested comments in view
        @comments = @comments.group_by(&:reply_id)
      end

      def create
        @comment = Post.find(params[:post_id])
                       .comments
                       .build(
                         comment_params.merge(
                           { account_id: current_account.id }
                         )
                       )

        unprocessable_entity(@comment) unless @comment.save
      end

      def update
        @comment = Comment.find(params[:id])
        return access_denied unless @comment.account == current_account

        if @comment.update(comment_params)
          render_resource(@comment)
        else
          unprocessable_entity(@comment)
        end
      end

      def destroy
        @comment = Comment.find(params[:id])
        return access_denied unless @comment.account == @current_account

        if @comment.deleted!
          head :no_content
        else
          unprocessable_entity(@comment)
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body, :reply_id)
      end

      def sort_by_params
        # Return specified sort_by param if whitelisted
        return params[:sort_by] if %w[best hot new top].include?(params[:sort_by])

        # Otherwise return default to sort by best
        'best'
      end
    end
  end
end
