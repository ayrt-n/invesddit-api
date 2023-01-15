module Api
  module V1
    class CommunitiesController < ApplicationController
      before_action :authenticate, only: %i[create]

      def create
        @community = Community.create(community_params)

        render_resource(@community)
      end

      private

      def community_params
        params.require(:community).permit(:sub_dir, :title, :description)
      end
    end
  end
end
