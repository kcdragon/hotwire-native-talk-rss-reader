class User < ApplicationRecord
  has_secure_password validations: false

  has_many :feeds, dependent: :destroy
  has_many :entries, through: :feeds
  has_many :sessions, dependent: :destroy

  enum :oauth_provider, { apple: 0, google: 1 }

  normalizes :email_address, with: ->(e) { e.strip.downcase if e }

  validates :email_address, presence: true, uniqueness: true, unless: :guest?
  validates :password, presence: true, on: :create, unless: -> { guest? || oauth_provider.present? }
  validates_confirmation_of :password, allow_nil: true
  validates :oauth_uid, presence: true, if: :oauth_provider?
  validates :oauth_provider, presence: true, if: :oauth_uid?

  scope :guest, -> { where(guest: true) }
  scope :registered, -> { where(guest: false) }
  scope :oauth, -> { where.not(oauth_provider: nil) }
end
