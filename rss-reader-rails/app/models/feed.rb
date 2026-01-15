class Feed < ApplicationRecord
  broadcasts_refreshes

  belongs_to :user

  has_many :entries, dependent: :destroy

  validates :rss_url, presence: true
  validate :rss_url_must_be_valid

  private

  def rss_url_must_be_valid
    return if rss_url.blank?

    URI.parse(rss_url)
  rescue URI::InvalidURIError
    errors.add(:rss_url, "is not a valid URL")
  end
end
