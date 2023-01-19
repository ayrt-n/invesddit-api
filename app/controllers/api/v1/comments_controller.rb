module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate, only: %i[create update]
      before_action :set_commentable, only: %i[create]

      def create
        @comment = @commentable.comments.create(
          comment_params.merge({ account_id: current_account.id })
        )

        render_resource(@comment)
      end

      def update
        @comment = Comment.find(params[:id])
        return access_denied unless @comment.account == current_account

        if @comment.update(comment_params)
          render json: @comment
        else
          validation_error(@comment)
        end
      end

      private

      def set_commentable
        if params[:post_id]
          @commentable = Post.find(params[:post_id])
        elsif params[:comment_id]
          @commentable = Comment.find(params[:comment_id])
        else
          # TO DO RENDER ERROR?
        end
      end

      def comment_params
        params.require(:comment).permit(:body)
      end
    end
  end
end
