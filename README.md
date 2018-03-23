# User Token

User token generation in Ruby for the [Tanker SDK](https://tanker.io/docs/latest).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tanker-user-token', git: 'https://github.com/SuperTanker/user-token-ruby', tag: 'v1.4.0'
```

And then execute:

    $ bundle

## Usage

The server-side code below demonstrates a typical flow to safely deliver user tokens to your users:

```ruby
require 'tanker-user-token'

# Store these configurations in a safe place
trustchain_id = '<trustchain-id>'
trustchain_private_key = '<trustchain-private-key>'

# Example server-side function in which you would implement check_auth(),
# retrieve_user_token() and store_user_token() to use your own authentication
# and data storage mechanisms:
def user_token(user_id)
  # Always ensure user_id is authenticated before returning a user token
  raise 'Not authenticated' unless check_auth(user_id)

  # Retrieve a previously stored user token for this user
  token = retrieve_user_token(user_id)

  # If not found, create a new user token
  if token.nil?
    token = Tanker::UserToken.generate(trustchain_id, trustchain_private_key, user_id)

    # Store the newly generated user token
    store_user_token(user_id)
  end

  # From now, the same user token will always be returned to a given user
  token
end
```

Read more about user tokens in the [Tanker guide](https://tanker.io/docs/latest/guide/server/).

Check the [examples](https://github.com/SuperTanker/user-token-ruby/examples) folder for usage examples.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SuperTanker/user-token-ruby.
