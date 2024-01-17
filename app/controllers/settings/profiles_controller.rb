class Settings::ProfilesController < ApplicationController

  def add_profile_to_user
    profile_id = params[:profile_id]
    user_id = params[:user_id]

    if(profile_id != "0")
      if(Profile.find(profile_id).assign_profile_to_user(user_id))
        flash[:notice] = "Subscriptionm assigned to user successfully"
      else
        flash[:alert] = "Subscriptionm already assigned to user"
      end
    else
      flash[:alert] = "You must select a subscription"
    end  
    redirect_to settings_profiles_path
  end

  def create_profile
    if(!helpers.input_is_empty?(params[:profile_name].strip))
      Profile.new(profile_name: params[:profile_name]).save
      flash[:notice] = "Subscription created successfully"
    else
      flash[:alert] = "Subscription name cannot be empty"
    end  
    redirect_to settings_profiles_path
  end

  def update_profile
    if(!helpers.input_is_empty?(params[:profile_name].strip))
      Profile.find(params[:profile_id]).update(profile_name: params[:profile_name])
      flash[:notice] = "Subscription updated successfully"
    else
      flash[:alert] = "Subscription name cannot be empty"
    end
    redirect_to settings_profiles_path
  end

  def delete_profile
    if(RUsersProfile.where(profile_id: params[:profile_id]).count > 0)
      RUsersProfile.where(profile_id: params[:profile_id]).destroy_all
    end

    if(RProfilesTag.where(profile_id: params[:profile_id]).count > 0)
      RProfilesTag.where(profile_id: params[:profile_id]).destroy_all
    end
    Profile.find(params[:profile_id]).destroy
    flash[:notice] = "Subscription deleted successfully"
    redirect_to settings_profiles_path
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
