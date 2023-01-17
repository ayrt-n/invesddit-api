module Api
  module V1
    class PostsController < ApplicationController
      def create
        @community = Community.friendly.find(params[:community_id])
        @post = @community.posts.create(post_params.merge({ account_id: current_account.id }))

        render_resource(@post)
      end

      private

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end