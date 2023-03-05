module Api
  module V1
    class AccountsController < ApplicationController
      before_action :authenticate, only: %i[edit update]

      def show
        @account = Account.friendly.find(params[:id])
      end

      def edit
        @current_account
      end

      def update
        if @current_account.update(account_params)
          render :edit
        else
          unprocessable_entity(@current_account)
        end
      end

      def communities
        @communities = @current_account.communities.includes(:avatar_attachment, :banner_attachment)
      end

      private

      def account_params
        params.require(:account).permit(:avatar, :banner)
      end
    end
  end
end
