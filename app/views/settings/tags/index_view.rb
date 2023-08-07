module Settings
    module Tags
      class IndexView < ApplicationView
  
        def initialize(tags:, profiles:)
          @tags = tags
          @profiles = profiles
        end
  
        def template
          div(class: "feed-settings", data: {behavior: "spinner"}) do
            render Settings::H1Component.new do
              "Create Tag"
            end
            # render(Settings::ControlGroupComponent.new(class: "mb-14")) do |group|
            #   group.item do
            #     render(partial: "settings/profiles/create_profile")
            #   end
            # end          
            render Settings::H1Component.new do
              "Manage Tags"
            end
            render(Settings::ControlGroupComponent.new(class: "mb-14")) do |group|
                group.item do
                  render(partial: "settings/tags/tag_managment", locals: { tags: @tags, profiles: @profiles })
                end
            end          
          end
        end
      end
    end
  end