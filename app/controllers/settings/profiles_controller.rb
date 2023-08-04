class Settings::ProfilesController < ApplicationController

  def add_profile_to_user
    Profile.find(params[:profile_id]).assign_profile_to_user(params[:user_id])
    redirect_to settings_profiles_path
  end

  def create_profile
    Profile.new(profile_name: params[:profile_name]).save
    redirect_to settings_profiles_path
  end
  
  
  def index
    @user = current_user
    @all_users = User.all
    @profiles = Profile.all
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
