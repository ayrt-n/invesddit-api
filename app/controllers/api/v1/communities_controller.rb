module Api
  module V1
    class CommunitiesController < ApplicationController
      def create
        @community = Community.create(community_params)

        render json: @community, status: :created
      end

      private

      def community_params
        params.require(:community).permit(:sub_dir, :title, :description)
      end
    end
  end
end