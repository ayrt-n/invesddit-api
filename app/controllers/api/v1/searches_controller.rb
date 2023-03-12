module Api
  module V1
    class SearchesController < ApplicationController
      def show
        @posts = Post.where('title ILIKE ?', "%#{Post.sanitize_sql_like(params[:q])}%")
                     .include_feed_associations

        @communities = Community.where('sub_dir ILIKE ?', "%#{Community.sanitize_sql_like(params[:q])}%")
                                .with_attached_avatar
                                .with_attached_banner

        @accounts = Account.where('username ILIKE ?', "%#{Account.sanitize_sql_like(params[:q])}%")
                           .with_attached_avatar
      end
    end
  end
end
