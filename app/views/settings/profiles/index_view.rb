module Settings
  module Profiles
    class IndexView < ApplicationView

      def initialize(all_users:, profiles:)
        @all_users = all_users
        @profiles = profiles
      end

      def template
        form_tag helpers.settings_profiles_path, method: :get, remote: true, class: "feed-settings", data: {behavior: "spinner"} do
          render Settings::H1Component.new do
            "Manage Profiles"
          end
          render(Settings::ControlGroupComponent.new(class: "mb-14")) do |group|
            @all_users.each do |user|
              group.item do
                div(data: { behavior: user.customer_id }) do
                  render(partial: "settings/profiles/user_managment", locals: { user: user, user_profiles: user.profiles, profiles: @profiles.where.not(id: user.profiles.ids) })
                end
              end
            end
          end          
        end
      end
    end
  end
end