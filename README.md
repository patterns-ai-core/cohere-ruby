# Cohere

<p>
    <img alt='Weaviate logo' src='https://static.wikia.nocookie.net/logopedia/images/d/d4/Cohere_2023.svg/revision/latest?cb=20230419182227' height='50' />
    +&nbsp;&nbsp;
    <img alt='Ruby logo' src='https://user-images.githubusercontent.com/541665/230231593-43861278-4550-421d-a543-fd3553aac4f6.png' height='40' />
</p>

Cohere API client for Ruby.

![Tests status](https://github.com/andreibondarev/cohere-ruby/actions/workflows/ci.yml/badge.svg) [![Gem Version](https://badge.fury.io/rb/cohere-ruby.svg)](https://badge.fury.io/rb/cohere-ruby)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add cohere-ruby

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install cohere-ruby

## Usage

### Instantiating API client
```ruby
client = Cohere::Client.new(
  api_key: ENV['COHERE_API_KEY']
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andreibondarev/cohere.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
