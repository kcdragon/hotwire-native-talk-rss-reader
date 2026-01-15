require "test_helper"

class UpdateFeedEntriesJobTest < ActiveJob::TestCase
  test "updates feed and creates entries" do
    feed = Feed.create!(
      user: users(:one),
      rss_url: "https://www.hotwireweekly.com/rss"
    )

    VCR.use_cassette("hotwireweekly-rss-feed") do
      UpdateFeedEntriesJob.perform_now(feed.id)
    end

    feed.reload
    assert_equal "Hotwire Weekly", feed.title
    assert_equal "Hotwire Weekly: Your go-to source for Hotwire insights, community engagement, and framework updates delivered weekly.", feed.description

    assert_equal 30, feed.entries.count

    entry = feed.entries.first
    assert_equal "Week 46 - Herb v0.8, Inline Edit Custom Element, and more!", entry.title
    assert_equal "https://www.hotwireweekly.com/archive/week-46-herb-v0-8-inline-edit-custom-element/", entry.url
    assert_equal Time.parse("2025-11-17 08:00:00 UTC"), entry.published_at
  end

  test "does not create duplicate entries when run multiple times" do
    feed = Feed.create!(
      user: users(:one),
      rss_url: "https://www.hotwireweekly.com/rss"
    )

    VCR.use_cassette("hotwireweekly-rss-feed") do
      UpdateFeedEntriesJob.perform_now(feed.id)
    end

    feed.reload
    assert_equal 30, feed.entries.count

    VCR.use_cassette("hotwireweekly-rss-feed") do
      UpdateFeedEntriesJob.perform_now(feed.id)
    end

    feed.reload
    assert_equal 30, feed.entries.count
  end
end
