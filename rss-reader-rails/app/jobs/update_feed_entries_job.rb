class UpdateFeedEntriesJob < ApplicationJob
  queue_as :default

  def perform(feed_id)
    feed = Feed.find(feed_id)

    uri = URI.parse(feed.rss_url)
    xml = Net::HTTP.get(uri)
    parsed_feed = Feedjira.parse(xml)

    feed.title = parsed_feed.title
    feed.description = parsed_feed.description
    feed.image_url = parsed_feed.image&.url if parsed_feed.respond_to?(:image)
    feed.save!

    parsed_feed.entries.each do |parsed_entry|
      entry = feed.entries.find_or_initialize_by(
        url: parsed_entry.url
      )

      summary = parsed_entry.summary
      if summary && summary.length > 500
        # it's likely not a summary, but the full content
        summary = nil
      end
      image_url = parsed_entry.image
      entry.update!(
        title: parsed_entry.title,
        published_at: parsed_entry.published,
        summary:,
        image_url:,
      )
    end

    feed.broadcast_refresh
  end
end
