# User Token

User token generation in ruby for the [Tanker SDK](https://tanker.io/docs/latest).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tanker-user-token', git: 'https://github.com/SuperTanker/user-token-ruby', tag: 'v1.4.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tanker-user-token

## Usage

```ruby
Tanker::UserToken.generate(trustchain_id, trustchain_private_key, user_id)
```

Check the [examples](https://github.com/SuperTanker/user-token-ruby/examples) folder for 
usage examples.

Read the Tanker documentation: https://tanker.io/docs/latest/guide/server/

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/SuperTanker/user-token-ruby.
