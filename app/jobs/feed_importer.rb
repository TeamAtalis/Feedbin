class FeedImporter
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: false

  def perform(import_item_id)
    import_item = ImportItem.find(import_item_id)
    import = import_item.import
    user = import.user

    feeds = begin
      FeedFinder.feeds(import_item.details[:xml_url], import_mode: true)
    rescue => exception
      import_item.update(status: :failed, error_class: exception.class.name, error_message: exception.message)
      []
    end

    if feeds.present?
      feed = feeds.first
      user.subscriptions.create_with(title: import_item.details[:title]).find_or_create_by(feed: feed)
      feed.tag(import_item.details[:tag], user, false) if import_item.details[:tag]
      import_item.complete!
    else
      import_item.failed!
    end

    import.with_lock do
      unless import.import_items.where(status: :pending).exists?
        import.update(complete: true)
      end
    end
  rescue ActiveRecord::RecordNotUnique
    import_item.complete!
  rescue => exception
    import_item.failed!
    raise exception
  end

  def find_feeds(import_item, user)

  rescue => e
    if Rails.env.development?
      raise e
    else
      []
    end
  end
end
