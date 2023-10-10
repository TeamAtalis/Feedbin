class ProfilesController < ApplicationController
    include SubscriptionConcern

    def index
        @user = current_user
        @my_profiles = @user.profiles
        @profiles = Profile.all
    end

    def subscribe 
        subscribe_profile(params[:profile_id])
        redirect_to root_path
    end
end