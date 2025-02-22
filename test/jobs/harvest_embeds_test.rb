require "test_helper"

class HarvestEmbedsTest < ActiveSupport::TestCase
  setup do
    flush_redis
    @user = users(:ben)
    @entry = create_entry(@user.feeds.first)
  end

  test "should harvest from iframe" do
    @entry.update(content: %(<iframe src="http://www.youtube.com/embed/video_id"></iframe>))

    assert_difference -> { Sidekiq.redis {|r| r.scard(HarvestEmbeds::SET_NAME) } }, +1 do
      HarvestEmbeds.new.perform(@entry.id)
    end

  end

  test "should harvest from youtube feed" do
    @entry.update(data: {youtube_video_id: "video_id"})

    assert_difference -> { Sidekiq.redis {|r| r.scard(HarvestEmbeds::SET_NAME) } }, +1 do
      HarvestEmbeds.new.perform(@entry.id)
    end
  end

  test "should create embed records" do
    @entry.update(data: {youtube_video_id: "video_id"}, provider_id: "video_id")
    @entry.provider_youtube!

    Sidekiq.redis {|r| r.sadd?(HarvestEmbeds::SET_NAME, "video_id") }
    stub_youtube_api
    assert_difference "Embed.count", +2 do
      HarvestEmbeds.new.perform(nil, true)
    end

    assert_equal("channel_id", @entry.reload.provider_parent_id)
  end

  test "should add provider_parent_id from existing embed" do
    Embed.youtube_video.create!(provider_id: "video_id", parent_id: "channel_id", data: {})

    @entry.update(data: {youtube_video_id: "video_id"}, provider_id: "video_id")
    @entry.provider_youtube!
    @entry.send(:provider_metadata)
    @entry.save!

    assert_equal("channel_id", @entry.reload.provider_parent_id)
  end

  def stub_youtube_api
    videos = {
      items: [
        {
          id: "video_id",
          snippet: {
            channelId: "channel_id"
          }
        }
      ]
    }
    stub_request(:get, %r{www.googleapis.com/youtube/v3/videos})
      .to_return body: videos.to_json, headers: {content_type: "application/json"}

    channels = {
      items: [
        {
          id: "channel_id"
        }
      ]
    }
    stub_request(:get, %r{www.googleapis.com/youtube/v3/channels})
      .to_return body: channels.to_json, headers: {content_type: "application/json"}
  end


end
