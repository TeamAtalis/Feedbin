class Settings::TagsController < ApplicationController

    def add_tag_to_profile
      profile_id = params[:profile_id]
      tag_id = params[:tag_id]

      if(profile_id != "0" || tag_id != "0")
        if(Profile.find(profile_id).assign_profile_to_tag(tag_id))
          flash[:notice] = "Tag assigned to profile successfully"
        else
          flash[:alert] = "Tag already assigned to profile"
        end
      else
        flash[:alert] = "You must select a profile and a tag"
      end  
      redirect_to settings_tags_path
    end
  
    def create_tag
      if(!helpers.input_is_empty?(params[:tag_name].strip))
        Tag.new(name: params[:tag_name]).save
        flash[:notice] = "Tag created successfully"
      else
        flash[:alert] = "Tag name cannot be empty"
      end
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
  