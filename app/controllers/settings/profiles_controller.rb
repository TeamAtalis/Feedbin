class Settings::ProfilesController < ApplicationController

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
