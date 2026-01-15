# RSS Reader

This is a simple RSS reader built with Rails.
It's using during my [Hotwire Native talks](https://mikedalton.co/talks/).

## Architecture

This repository contains a Hotwire Native app.
rss-reader-rails contains the Rails app.
rss-reader-android contains the Android app.
rss-reader-ios contains the iOS app.

## Setup

If you want to test the OAuth flow locally, you will need to replace the encoded credentials with your own.
The expected format for the credentials is the following:

```yaml
apple:
  service_identifier: ""
  team_id: ""
  key_id: ""
  private_key: |
    -----BEGIN PRIVATE KEY-----
    ...
    -----END PRIVATE KEY-----

google:
  client_id: ""
  client_secret: ""

mission_control:
  http_basic_auth_user: ""
  http_basic_auth_password: ""
```
