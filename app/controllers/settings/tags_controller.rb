class Settings::TagsController < ApplicationController

    def add_tag_to_profile
      profile_id = params[:profile_id]
      tag_id = params[:tag_id]

      if(profile_id == "0" || tag_id == "0")
        # To implement a funcion that allows admin to add a tag to profile
        redirect_to settings_tags_path
      end
    #   Profile.find(params[:profile_id]).assign_profile_to_user(params[:user_id])
    #   redirect_to settings_profiles_path
    end
  
    def create_tag
      Tag.new(name: params[:tag_name]).save
      redirect_to settings_tags_path
    end
    
    def index
      @tags = Tag.all.order("name")
      @profiles = Profile.all.order("profile_name")

      store_location
  
      respond_to do |format|
        format.html do
          view = Settings::Tags::IndexView.new(
            tags: @tags,
            profiles: @profiles,
          )
          render view, layout: "settings"
        end
        # default index.js.erb
        format.js {}
      end  
    end
  end
  