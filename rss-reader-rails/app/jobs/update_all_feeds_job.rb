class UpdateAllFeedsJob < ApplicationJob
  queue_as :default

  def perform
    Feed.all.each do |feed|
      UpdateFeedEntriesJob.perform_later(feed.id)
    end
  end
end
