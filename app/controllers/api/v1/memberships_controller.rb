module Api
  module V1
    class MembershipsController < ApplicationController
      before_action :authenticate, only: %i[create destroy]

      # POST /communities/:community_id/memberships
      # Route to join the community as a member
      def create
        community = Community.friendly.find(params[:community_id])
        @membership = @current_account.join_community(community)

        if @membership
          head :no_content
        else
          unprocessable_entity(@membership)
        end
      end

      # DESTROY /communities/:community_id/memberships
      # Route to leave the community as a member (admin status will be retained)
      def destroy
        community = Community.friendly.find(params[:community_id])
        @membership = @current_account.leave_community(community)

        if @membership
          head :no_content
        else
          unprocessable_entity(@membership)
        end
      end
    end
  end
end
