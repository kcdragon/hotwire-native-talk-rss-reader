ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require_relative "test_helpers/session_test_helper"

# https://benoittgt.github.io/vcr/
VCR.configure do |config|
  config.cassette_library_dir = "test/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.default_cassette_options = { match_requests_on: [ :method, :uri, :body ] }
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
