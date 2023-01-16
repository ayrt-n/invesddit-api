module Api
  module V1
    class CommunitiesController < ApplicationController
      before_action :authenticate, only: %i[create]

      def index
        @communities = Community.all

        render json: { communities: @communities }
      end

      def show
        @community = Community.where(sub_dir: params['id']).first

        render json: { community: @community }
      end

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
