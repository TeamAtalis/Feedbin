class Settings::ProfilesController < ApplicationController

  def add_profile_to_user
    profile_id = params[:profile_id]
    user_id = params[:user_id]

    if(profile_id != "0")
      if(Profile.find(profile_id).assign_profile_to_user(user_id))
        flash[:notice] = "Profile assigned to user successfully"
      else
        flash[:alert] = "Profile already assigned to user"
      end
    else
      flash[:alert] = "You must select a profile"
    end  
    redirect_to settings_profiles_path
  end

  def create_profile
    if(!helpers.input_is_empty?(params[:profile_name].strip))
      Profile.new(profile_name: params[:profile_name]).save
      flash[:notice] = "Profile created successfully"
    else
      flash[:alert] = "Profile name cannot be empty"
    end  
    redirect_to settings_profiles_path
  end

  def update_profile
    puts params[:profile_name]
    if(!helpers.input_is_empty?(params[:profile_name].strip))
      Profile.find(params[:profile_id]).update(profile_name: params[:profile_name])
      flash[:notice] = "Profile updated successfully"
    else
      flash[:alert] = "Profile name cannot be empty"
    end
    redirect_to settings_profiles_path
  end

  def delete_profile
    puts params[:profile_id]
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
