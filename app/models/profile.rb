class Profile < ApplicationRecord
    
    has_many :r_users_profiles
    has_many :users, through: :r_users_profiles

    has_many :r_profiles_tags
    has_many :tags, through: :r_profiles_tags
  
    # Desc: This method is used to assign a profile to users.
    #       First, try to find out if the user has the profile.
    #           -If the user has the profile, it will do nothing.
    #           -If the relationship between user and profile 
    #            is not found, then do insert
    #
    # input parameters: 
    #       @params[:user_id] [int]: id of User
    #
    def assign_profile_to_user(user_id)
        if RUsersProfile.new(user_id: user_id, profile_id: self.id).save
            self.tags.each do |tag|
                tag.assign_new_feeds(user_id)
                Entry.mark_unread_entries_from_tag(tag.id, user_id)
            end
        else
            raise "Profile already assigned to user"
        end  
    end

    # Desc: This method is used to assign a profile to users.
    #       First, try to find out if the user has the profile.
    #           -If the user has the profile, it will do nothing.
    #           -If the relationship between user and profile
    #            is not found, then do insert
    #
    # input parameters: 
    #       @params[:tag_id] [int]: id of Tag
    #
    # def assign_profile_to_user(tag_id)
    #     RProfilesTag.new(profile_id: self.id, tag_id: tag_id).save ? "Tag assigned to profile" : "Tag already assigned to profile"
    # end
end
