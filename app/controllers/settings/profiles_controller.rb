class Settings::ProfilesController < ApplicationController

  def add_profile_to_user
    profile_id = params[:profile_id]
    user_id = params[:user_id]

    if(profile_id != "0")
      Profile.find(profile_id).assign_profile_to_user(user_id)
      redirect_to settings_profiles_path
    end
  end

  def create_profile
    if(!helpers.input_is_empty?(params[:profile_name].strip))
      Profile.new(profile_name: params[:profile_name]).save
      redirect_to settings_profiles_path
    end
  end
  
  def index
    @user = current_user
    @all_users = User.all.order("email")
    @profiles = Profile.all.order("profile_name")
    
    store_location

    respond_to do |format|
      format.html do
        view = Settings::Profiles::IndexView.new(
          all_users: @all_users,
          profiles: @profiles,
        )
        render view, layout: "settings"
      end
      # default index.js.erb
      format.js {}
    end  
  end
end
