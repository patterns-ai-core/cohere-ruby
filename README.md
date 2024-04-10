# Cohere

<p>
    <img alt='Weaviate logo' src='https://static.wikia.nocookie.net/logopedia/images/d/d4/Cohere_2023.svg/revision/latest?cb=20230419182227' height='50' />
    +&nbsp;&nbsp;
    <img alt='Ruby logo' src='https://user-images.githubusercontent.com/541665/230231593-43861278-4550-421d-a543-fd3553aac4f6.png' height='40' />
</p>

Cohere API client for Ruby.

Part of the [Langchain.rb](https://github.com/andreibondarev/langchainrb) stack.

![Tests status](https://github.com/andreibondarev/cohere-ruby/actions/workflows/ci.yml/badge.svg)
[![Gem Version](https://badge.fury.io/rb/cohere-ruby.svg)](https://badge.fury.io/rb/cohere-ruby)
[![Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/gems/cohere-ruby)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/andreibondarev/cohere-ruby/blob/main/LICENSE.txt)
[![](https://dcbadge.vercel.app/api/server/WDARp7J2n8?compact=true&style=flat)](https://discord.gg/WDARp7J2n8)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add cohere-ruby

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install cohere-ruby

## Usage

### Instantiating API client

```ruby
require "cohere"

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

### Chat

```ruby
client.chat(
    message: "Hey! How are you?"
)
```

`chat` supports a streaming option. You can pass a block to the `chat` method and it will yield a new chunk as soon as it is received.

```ruby
client.chat(message: "Hey! How are you?", stream: true) do |chunk, overall_received_bytes|
  puts "Received #{overall_received_bytes} bytes: #{chunk.force_encoding(Encoding::UTF_8)}"
end
```

`force_encoding` is preferred to avoid JSON parsing issue when Cohere returns emoticon.

`chat` supports Tool use (function calling).

```ruby
tools = [
   {
     name: "query_daily_sales_report",
     description: "Connects to a database to retrieve overall sales volumes and sales information for a given day.",
     parameter_definitions: {
       day: {
         description: "Retrieves sales data for this day, formatted as YYYY-MM-DD.",
         type: "str",
         required: true
       }
     }
   }
]

message = "Can you provide a sales summary for 29th September 2023, and also give me some details about the products in the 'Electronics' category, for example their prices and stock levels?"

client.chat(
  model: model,
  message: message,
  tools: tools,
)
```

Once the function is called, results are passed through `tool_results` array so you can get insights on the next reply.

```ruby
client.chat(
  model: model,
  message: message,
  tools: tool,
  tool_results: [
    {
      rows: [['Ruby', 42]]
    }
  ]
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
