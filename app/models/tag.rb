class Tag < ApplicationRecord
  attr_accessor :count, :user_feeds

  has_many :r_profiles_tags
  has_many :profiles, through: :r_profiles_tags
  has_many :taggings
  has_many :feeds, through: :taggings

  # OLD FEATURE
  def self.rename(user, old_tag, new_name)
    new_name = new_name.strip.delete(",")

    new_tag = Tag.where(name: new_name).first_or_create
    user.taggings.where(tag: old_tag).update_all(tag_id: new_tag.id)

    Search::ActionTags.perform_async(user.id, new_tag.id, old_tag.id)

    new_tag
  end

  # NEW FEATURE
  def self.rename_tag(user, old_tag, new_name)
    new_name = new_name.strip.delete(",")

    Tag.where(name: old_tag.name).update_all(name: new_name)
    updated_tag = Tag.where(id: old_tag.id).first

    updated_tag
  end

  def self.destroy(user, tag)
    Tagging.where(tag: tag, user: user).destroy_all
    Search::ActionTags.perform_async(user.id, nil, tag.id)
  end

  def sourceable
    Sourceable.new(
      type: self.class.name,
      id: id,
      title: name,
      section: "Tags",
      jumpable: true
    )
  end

  # Desc: This method is used to assign all tags feeds
  #       to user.
  #       The user may already be subscribed to the feed.
  #       If he is suscribed, it will do nothing.
  #       Finally the feed is inserted into the folder.
  #
  # input parameters:
  #       @params[:user_id] [int]: id of User
  #
  def assign_new_feeds(user_id)
    # Insert operations
    self.feeds.pluck(:id).each do |feed_id|
      Subscription.find_or_create_by(user_id: user_id, feed_id: feed_id).save # Subcribe to all new feeds
      Tagging.find_or_initialize_by(feed_id: feed_id, user_id: user_id, tag_id: self.id).save # Insert new feed to the folder
    end
  end
end
