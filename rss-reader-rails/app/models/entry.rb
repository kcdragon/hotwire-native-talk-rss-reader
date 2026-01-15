class Entry < ApplicationRecord
  belongs_to :feed

  validate :image_url_must_be_valid

  private

  def image_url_must_be_valid
    return if image_url.blank?

    URI.parse(image_url)
  rescue URI::InvalidURIError
    errors.add(:image_url, "is not a valid URL")
  end
end
