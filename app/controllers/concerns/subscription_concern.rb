module SubscriptionConcern
    extend ActiveSupport::Concern

    def subscribe_profile(profile_id)
        @user = current_user
        Profile.find(profile_id).assign_profile_to_user(@user.id)
        flash[:notice] = "Profile subscribed successfully"
    end
end