module Settings
  module Shared
    class StarredFeedUrl < ApplicationComponent
      def initialize(user:)
        @user = user
      end

      def template
        if @user.setting_on?(:starred_feed_enabled)
          div class: "truncate" do
            plain "Feed URL: "
            link_to helpers.starred_url(@user.starred_token, format: :xml), helpers.starred_url(@user.starred_token, format: :xml)
          end
        else
          plain "For integrating with other services"
          plain "."
        end
      end
    end
  end
end
