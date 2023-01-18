module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate, only: %i[create update]

      def index
        @posts = Post.all

        render json: { posts: @posts }
      end

      def create
        @community = Community.friendly.find(params[:community_id])
        @post = @community.posts.create(post_params.merge({ account_id: current_account.id }))

        render_resource(@post)
      end

      def update
        @post = Post.find(params[:id])

        return access_denied unless @post.account == current_account

        if @post.update(post_params)
          render json: @post
        else
          render validation_error(@post)
        end
      end

      private

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
