class ProfilesController < ApplicationController
    
    def index
        @user = current_user
        @my_profiles = @user.profiles

        @profiles = Profile.all
    end

    def subscribe
        Profile.find(params[:profile_id]).assign_profile_to_user(@user.id)
        redirect_to root_path
    end

    def link_tags
        Profile.find(params[:profile_id]).assign_profile_to_tag(params[:tag_id], params[:user_id])
        redirect_to root_path
    end
end
