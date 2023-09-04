class FeedPresenter < BasePresenter
  presents :feed

  def feed_link(link: nil, behavior: nil, has_profile: nil, &block)
    default_behavior = "selectable show_entries open_item feed_link renamable user_title"
    behavior_suffix = @user.try(:admin?) || !has_profile ? " has_settings" : ""

    args = [
      link || @template.feed_entries_path(feed),
      remote: true,
      class: "feed-link",
      data: {
        behavior: behavior || "#{default_behavior}#{behavior_suffix}",
        settings_path: @template.edit_subscription_path(feed, app: true),
        feed_id: feed.id,
        sourceable_target: "source",
        action: "sourceable#selected",
        sourceable_payload_param: feed.sourceable.to_h,
        mark_read: {
          type: "feed",
          data: feed.id,
          message: "Mark #{feed.title} as read?"
        }.to_json
      }
    ]

    @template.link_to(*args, &block)
  end
end

