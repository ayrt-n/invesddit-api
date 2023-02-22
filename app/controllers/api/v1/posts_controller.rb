module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate, only: %i[create update destroy]

      def index
        @posts = Post.all
                     .includes(:account, :community)
                     .with_attached_image

        # Filter posts to either community (if specified) or current accounts communities
        # Unless user has specified they want to view all via filter param
        if params[:community] || (@current_account && params[:filter] != 'all')
          @posts = @posts.filter_by_communities(
            params[:community] || @current_account.communities_friendly_ids
          )
        end

        # Order posts by sort by param - default hot ranking
        @posts = @posts.send("sort_by_#{sort_by_params}")

        @current_account_votes = Vote.where(votable: @posts).where(account: @current_account)
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

      def sort_by_params
        # Return specified sort_by param if whitelisted
        return params[:sort_by] if %w[hot new top].include?(params[:sort_by])

        # Otherwise return default to sort by hot
        'hot'
      end
    end
  end
end
