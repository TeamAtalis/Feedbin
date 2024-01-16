module Settings
  module Profiles
    class IndexView < ApplicationView

      def initialize(all_users:, profiles:)
        @all_users = all_users
        @profiles = profiles
      end

      def template
        div(class: "feed-settings", data: {behavior: "spinner"}) do
          render Settings::H1Component.new do
            "Create a Subscription"
          end
          render(Settings::ControlGroupComponent.new(class: "mb-14")) do |group|
            group.item do
              render(partial: "settings/profiles/create_profile")
            end
          end          
          render Settings::H1Component.new do
            "Delete a Subscription"
          end
          render(Settings::ControlGroupComponent.new(class: "mb-14")) do |group|
            @profiles.each do |profile|
              group.item do
                render(partial: "settings/profiles/update_profile", locals: { profile: profile })
              end
            end  
          end          
          render Settings::H1Component.new do
            "Add Subscriptions to Users"
          end
          render(Settings::ControlGroupComponent.new(class: "mb-14")) do |group|
            @all_users.each do |user|
              group.item do
                render(partial: "settings/profiles/user_managment", locals: { user: user, user_profiles: user.profiles.order("profile_name"), profiles: @profiles.where.not(id: user.profiles.ids) })
              end
            end
          end          
        end
      end
    end
  end
end