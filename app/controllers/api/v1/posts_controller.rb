module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate, only: %i[create update destroy]
      before_action :sanitize_pagination_params, only: %i[index search]

      # GET /posts
      def index
        # Query for and build posts feed
        @posts = feed_strategy
                 .new(
                   collection: Post.published.include_feed_associations,
                   current_account: @current_account
                 )
                 .build(params.slice(
                          :community_id,
                          :account_id,
                          :sort_by,
                          :filter
                        ))
                 .page(params[:page], params[:limit])

        # Query for votes by the current account for the posts queried and transform to hash
        # to make it easier to work with in the view
        @votes = Vote.for_votables_and_account(@posts, @current_account).group_by(&:votable_id)
      end

      # GET /posts/:id
      def show
        @post = Post.find(params[:id])
        @vote = Vote.find_by(votable: @post, account: @current_account)
      end

      # POST /community/:community_id/posts
      def create
        @community = Community.friendly.find(params[:community_id])
        @post = @community
                .posts
                .build(
                  create_post_params.merge(
                    {
                      account_id: @current_account.id,
                      type: params[:type]
                    }
                  )
                )

        # If unable to save post, render unprocessable entity (422) with errors
        unprocessable_entity(@post) unless @post.save
      end

      # PATCH /posts/:id
      def update
        @post = Post.find(params[:id])
        return access_denied unless @post.account == @current_account

        if @post.update(update_post_params)
          head :no_content
        else
          unprocessable_entity(@post)
        end
      end

      # DESTROY /posts/:id
      def destroy
        @post = Post.find(params[:id])
        return access_denied unless @post.account == @current_account

        # Soft delete - does not actual destroy record but changes post.status to "deleted"
        if @post.deleted!
          head :no_content
        else
          unprocessable_entity(@post)
        end
      end

      # GET /search/posts
      def search
        # Search posts for given query string
        @posts = Post.search(params[:q])
                     .page(params[:page], params[:limit])
      end

      private

      # Allowlist for post create parameters
      def create_post_params
        params.require(:post).permit(:title, :body, :image)
      end

      # Allowlist for post update parameters
      def update_post_params
        params.require(:post).permit(:body)
      end

      # Determine correct query strategy for building post index feed
      def feed_strategy
        case params[:strategy]
        when 'community'
          CommunityFeedQuery
        when 'account'
          ProfileFeedQuery
        else
          HomeFeedQuery
        end
      end
    end
  end
end
