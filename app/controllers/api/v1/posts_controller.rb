module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate, only: %i[create update destroy]

      def index
        # Query for and build posts index feed
        @posts = PostFeedQuery
                 .new(
                   posts: Post.all.include_feed_associations,
                   current_account: @current_account
                 )
                 .build_feed(params.slice(
                               :community_id,
                               :account_id,
                               :sort_by,
                               :filter
                             ))

        # Get all votes by the current account for the posts queried
        @current_account_votes = Vote.for_votables_and_account(@posts, @current_account)
      end

      def show
        @post = Post.find(params[:id])
        @current_account_vote = Vote.find_by(votable: @post, account: @current_account)
      end

      def create
        @community = Community.friendly.find(params[:community_id])
        @post = @community
                .posts
                .build(
                  post_params.merge(
                    {
                      account_id: @current_account.id,
                      type: params[:type]
                    }
                  )
                )

        unprocessable_entity(@post) unless @post.save
      end

      def update
        @post = Post.find(params[:id])
        return access_denied unless @post.account == @current_account

        if @post.update(post_params)
          render :show
        else
          unprocessable_entity(@post)
        end
      end

      def destroy
        @post = Post.find(params[:id])
        return access_denied unless @post.account == @current_account

        if @post.destroy
          head :no_content
        else
          unprocessable_entity(@post)
        end
      end

      private

      def post_params
        params.require(:post).permit(:title, :body, :image)
      end
    end
  end
end
