module Api
  module V1
    class CommunitiesController < ApplicationController
      before_action :authenticate, only: %i[create update]

      def index
        params[:q] ||= ''

        @communities = Community.where('sub_dir ILIKE ?', "%#{Community.sanitize_sql_like(params[:q])}%")
                                .limit(5)
                                .with_attached_avatar
                                .with_attached_banner
      end

      def show
        @community = Community.friendly.find(params['id'])
      end

      def create
        # Create community and set the creator (current account) as the admin
        @community = Community.new(community_params)
        @community.memberships.build(account_id: current_account.id, role: 'admin')

        # If save successul render community, else render errors
        unprocessable_entity(@community) unless @community.save
      end

      def update
        @community = Community.friendly.find(params['id'])
        return access_denied unless @community.admins.include?(current_account)

        if @community.update(community_update_params)
          render :show
        else
          unprocessable_entity(@community)
        end
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
