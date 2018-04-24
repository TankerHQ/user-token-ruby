# User Token [![Travis][build-badge]][build]

User token generation in Ruby for the [Tanker SDK](https://tanker.io/docs/latest).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tanker-user-token', git: 'https://github.com/SuperTanker/user-token-ruby' #, tag: 'vX.Y.Z'
```

And then execute:

    $ bundle

Note: this gem depends on the [rbnacl-libsodium](https://github.com/crypto-rb/rbnacl-libsodium) gem, which packages the [libsodium cryptographic library](https://download.libsodium.org/doc/). So there should be no need to install libsodium through system packages.

## Usage

The server-side code below demonstrates a typical flow to safely deliver user tokens to your users:

```ruby
require 'tanker-user-token'

# Store these configurations in a safe place
trustchain_id = '<trustchain-id>'
trustchain_private_key = '<trustchain-private-key>'

# Fetch a previously stored user token
def retrieve_user_token(user_id)
  # ...
end

# Store a previously generated user token
def store_user_token(user_id, token)
  # ...
end

# Called during signin / signup of your users.
# 
# Send a user token, generated if necessary, but only to
# authenticated users
def user_token(user_id)
  raise 'Not authenticated' unless check_auth(user_id)

  token = retrieve_user_token(user_id)

  if token.nil?
    token = Tanker::UserToken.generate(trustchain_id, trustchain_private_key, user_id)
    store_user_token(user_id, token)
  end

  token
end
```

Read more about user tokens in the [Tanker guide](https://tanker.io/docs/latest/guide/server/).

Check the [examples](https://github.com/SuperTanker/user-token-ruby/tree/master/examples/) folder for usage examples.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SuperTanker/user-token-ruby.

[build-badge]: https://travis-ci.org/SuperTanker/user-token-ruby.svg?branch=master
[build]: https://travis-ci.org/SuperTanker/user-token-ruby
