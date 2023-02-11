module Api
  module V1
    class MembershipsController < ApplicationController
      before_action :authenticate, only: %i[create destroy]

      def create
        @membership = @current_account.join_community(params[:community_id])

        if @membership
          render_resource(@membership)
        else
          unprocessable_entity(@membership)
        end
      end

      def destroy
        @community = Community.friendly.find(params[:community_id])
        @membership = @current_account.memberships.where(community: @community)
        return not_found unless @membership

        if @membership.destroy_all
          head :no_content
        else
          unprocessable_entity(@membership)
        end
      end
    end
  end
end
