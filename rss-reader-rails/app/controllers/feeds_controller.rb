class FeedsController < ApplicationController
  def index
    @feeds =
      current_user.feeds
        .left_joins(:entries)
        .group("feeds.id")
        .order(Arel.sql("COALESCE(MAX(entries.published_at), feeds.created_at) DESC"))
  end

  def new
    @feed = Feed.new
  end

  def create
    @feed = current_user.feeds.build(feed_params)
    if @feed.save
      UpdateFeedEntriesJob.perform_later(@feed.id)
      redirect_to feed_path(@feed), notice: "Feed created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @feed = current_user.feeds.find(params[:id])
  end

  def destroy
    @feed = current_user.feeds.find(params[:id])
    @feed.destroy
    redirect_to feeds_path, notice: "Feed deleted successfully!"
  end

  private

  def feed_params
    params.require(:feed).permit(:rss_url)
  end
end
