class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :feed
  belongs_to :user

  after_commit :update_actions, on: [:create, :destroy]

  # Desc: Create a new instance of Tagging. 
  #
  # input parameters: 
  #       @params[:feed_id] [int]: id of the Feed
  #       @params[:user_id] [int]: id of the User to subcribe this new feed
  #       @params[:tag_id] [int]: id of Tag that the feed will be present.
  #
  def self.create(feed_id, user_id, tag_id)
    Tagging.new(feed_id: feed_id, user_id: user_id, tag_id: tag_id,
      created_at: Time.now, updated_at: Time.now ).save
  end

  def update_actions
    actions = user.actions.where("? = ANY (tag_ids)", tag_id).pluck(:id)
    Search::TouchActions.perform_async(actions)
  end

  def self.build_tag_map
    items = group(:feed_id).pluck(Arel.sql("feed_id, array_agg(tag_id)"))
    feed_ids = items.map { |item| item.first }
    excluded = Feed.where(id: feed_ids).pages.pluck(:id)
    items.each_with_object({}) do |(feed_id, tag_ids), hash|
      unless excluded.include?(feed_id)
        hash[feed_id] = tag_ids
      end
    end
  end

  def self.build_feed_map
    items = group(:tag_id).pluck(Arel.sql("tag_id, array_agg(feed_id)"))
    items.each_with_object({}) do |(tag_id, feed_ids), hash|
      hash[tag_id] = feed_ids
    end
  end
end
