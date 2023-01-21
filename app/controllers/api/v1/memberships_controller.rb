module Api
  module V1
    class MembershipsController < ApplicationController
      before_action :authenticate, only: %i[create]

      def create
        @community = Community.friendly.find(params[:community_id])
        @membership = @community.memberships.build(account_id: current_account.id)

        if @membership.save
          render_resource(@membership)
        else
          unprocessable_entity(@membership)
        end
      end

      def destroy
        @membership = Membership.find(params[:id])
        return access_denied unless @membership.account == current_account

        if @membership.destroy
          head :no_content
        else
          unprocessable_entity(@membership)
        end
      end
    end
  end
end
