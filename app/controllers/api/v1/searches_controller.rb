module Api
  module V1
    class SearchesController < ApplicationController
      def show
        # Get all published posts where title matches search term
        @posts = Post.where('title ILIKE ?', "%#{Post.sanitize_sql_like(params[:q])}%")
                     .published
                     .include_feed_associations

        # Get all communities where sub_dir matches search term
        @communities = Community.where('sub_dir ILIKE ?', "%#{Community.sanitize_sql_like(params[:q])}%")
                                .with_attached_avatar
                                .with_attached_banner

        # Get all accounts where username matches search term
        @accounts = Account.where('username ILIKE ?', "%#{Account.sanitize_sql_like(params[:q])}%")
                           .with_attached_avatar
      end
    end
  end
end
