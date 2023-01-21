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
    end
  end
end
