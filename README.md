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
### Generate
```ruby
client.generate(
    prompt: "Once upon a time in a magical land called"
)
```

### Embed
```ruby
client.embed(
    texts: ["hello!"]
)
```

### Classify
```ruby
examples = [
    { text: "Dermatologists don't like her!", label: "Spam" },
    { text: "Hello, open to this?", label: "Spam" },
    { text: "I need help please wire me $1000 right now", label: "Spam" },
    { text: "Nice to know you ;)", label: "Spam" },
    { text: "Please help me?", label: "Spam" },
    { text: "Your parcel will be delivered today", label: "Not spam" },
    { text: "Review changes to our Terms and Conditions", label: "Not spam" },
    { text: "Weekly sync notes", label: "Not spam" },
    { text: "Re: Follow up from today's meeting", label: "Not spam" },
    { text: "Pre-read for tomorrow", label: "Not spam" }
]

inputs = [
  "Confirm your email address",
  "hey i need u to send some $",
]

client.classify(
    examples: examples,
    inputs: inputs
)
```

### Tokenize
```ruby
client.tokenize(
    text: "hello world!"
)
```

### Detokenize
```ruby
client.detokenize(
    tokens: [33555, 1114 , 34]
)
```

### Detect language
```ruby
client.detect_language(
    texts: ["Здравствуй, Мир"]
)
```

### Summarize
```ruby
client.summarize(
    text: "..."
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec spec/` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andreibondarev/cohere.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
