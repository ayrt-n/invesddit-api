module Api
  module V1
    class CommunitiesController < ApplicationController
      before_action :authenticate, only: %i[create update]
      before_action :sanitize_pagination_params, only: :search

      # GET /communities/:id
      def show
        @community = Community.friendly.find(params['id'])
      end

      # POST /communities
      def create
        # Create community and set the creator (current account) as an admin and member
        @community = Community.new(community_params)
        @community.memberships.build(account_id: current_account.id, role: 'admin')
        @community.memberships.build(account_id: current_account.id, role: 'member')

        # If save successul render community, else render errors
        unprocessable_entity(@community) unless @community.save
      end

      # PATCH /communities/:id
      def update
        @community = Community.friendly.find(params['id'])
        return access_denied unless @community.admins.include?(current_account)

        if @community.update(community_update_params)
          render :show
        else
          unprocessable_entity(@community)
        end
      end

      # GET /search/communities
      def search
        # Search communities for given query string
        @communities = Community.search(params[:q])
                                .page(params[:page], params[:limit])
      end

      private

      def community_params
        params.require(:community).permit(:sub_dir, :title, :description, :avatar, :banner)
      end

      def community_update_params
        params.require(:community).permit(:title, :description, :avatar, :banner)
      end
    end
  end
end
