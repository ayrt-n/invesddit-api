module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate, only: %i[create update]
      before_action :set_commentable, only: %i[create]

      def index
        @comments = Post.find(params[:post_id]).comments.includes(:account)
        @comments = @comments.send("sort_by_#{sort_by_params}")

        render :index
      end

      def create
        @comment = @commentable.comments.build(
          comment_params.merge({ account_id: current_account.id })
        )

        if @comment.save
          render_resource(@comment)
        else
          unprocessable_entity(@comment)
        end
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

      private

      def set_commentable
        @commentable = params[:post_id] ? Post.find(params[:post_id]) : Comment.find(params[:comment_id])
      end

      def comment_params
        params.require(:comment).permit(:body)
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
