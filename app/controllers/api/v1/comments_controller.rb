module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate, only: %i[create update]

      # GET /posts/:post_id/comments
      def index
        @comments = Post.find(params[:post_id]).comments.includes(account: [:avatar_attachment])
        @comments = @comments.send("sort_by_#{sort_by_params}")

        # Get all votes by the current account for the comments queried
        @votes = Vote.for_votables_and_account(@comments, @current_account).group_by(&:votable_id)

        # Group comments by reply_id to work with top-level and nested comments in view
        @comments = @comments.group_by(&:reply_id)
      end

      # POST /posts/:post_id/comments
      def create
        @comment = Post.find(params[:post_id])
                       .comments
                       .build(
                         create_comment_params.merge(
                           { account_id: current_account.id }
                         )
                       )

        if @comment.save
          render partial: 'api/v1/comments/comment', locals: { comment: @comment }
        else
          unprocessable_entity(@comment)
        end
      end

      # PATCH /comments/:id
      def update
        @comment = Comment.find(params[:id])
        return access_denied unless @comment.account == current_account

        if @comment.update(update_comment_params)
          head :no_content
        else
          unprocessable_entity(@comment)
        end
      end

      # DESTROY /comments/:id
      def destroy
        @comment = Comment.find(params[:id])
        return access_denied unless @comment.account == @current_account

        if @comment.soft_delete!
          head :no_content
        else
          unprocessable_entity(@comment)
        end
      end

      private

      # Allowlist for create comment params
      def create_comment_params
        params.require(:comment).permit(:body, :reply_id)
      end

      # Allowlist for update comment params
      def update_comment_params
        params.require(:comment).permit(:body)
      end

      # Allowlist for sort_by method
      def sort_by_params
        # Return specified sort_by param if whitelisted
        return params[:sort_by] if %w[best hot new top].include?(params[:sort_by])

        # Otherwise return default to sort by best
        'best'
      end
    end
  end
end
