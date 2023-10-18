namespace :feedbin do
  desc "When an admin modify a profile, all suscribes recive the update"
  task :update_profile, [:feed_id, :user_id ] => :environment do |_, args|
    feed = Feed.find(args[:feed_id])
    user = User.find(args[:user_id]) 
    
    # Get the tags to update
    present_tag_feed = Feed.find(feed.id).taggings.distinct.pluck(:tag_id) # Get all the tags that have this feed
    tag_on_profile = [] # get all tag that are from profiles 
    profile_ids = [] # get profiles ids for update the useres
    for tag_id in present_tag_feed
      if Tag.find(tag_id).profiles.present?
        tag_on_profile.push(tag_id)
        profile_ids = profile_ids + Tag.find(tag_id).profiles.distinct.pluck(:id)
      end
    end
    profile_ids = profile_ids.uniq # Remove the repeated elements

    users_to_update = []
    for profile_id in profile_ids
      users_to_update = users_to_update + RUsersProfile.where(profile_id: profile_id).pluck(:user_id) 
    end
    users_to_update = users_to_update.uniq
    users_to_update.delete_if { |posible_admin| posible_admin == user.id } # delete the user that make the update
    
    # Update all users
    for user_id in users_to_update 
      Subscription.subscribe(feed.id, user_id, tag_on_profile)
    end
  end
end