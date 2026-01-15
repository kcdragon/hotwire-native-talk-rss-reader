class EntriesController < ApplicationController
  def index
    @entries = current_user.entries.includes(:feed)
    @entries = @entries.where.not(liked_at: nil) if params[:filter] == "liked"
    @entries = @entries.order(published_at: :desc)
  end

  def mark_as_read
    @entry = current_user.entries.find(params[:id])
    @entry.update(read_at: Time.current)
  end

  def mark_as_unread
    @entry = current_user.entries.find(params[:id])
    @entry.update(read_at: nil) if @entry.read_at.present?
  end

  def toggle_like
    @entry = current_user.entries.find(params[:id])
    liked_at = @entry.liked_at.present? ? nil : Time.current
    @entry.update(liked_at:)
  end
end
