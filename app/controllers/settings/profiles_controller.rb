class Settings::ProfilesController < ApplicationController

  def new
    @profile = Profile.all
  end

  def admin_subscribe
    Profile.find(params[:profile_id]).assign_profile_to_user(@user.id)
    render json: { success: true, message: "Profile assigned to user successfully" }
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

  def show
  end

  def edit
  end
end
