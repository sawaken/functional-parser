# FunctionalParser

Yet another functional library for text-parsing by Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'functional_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install functional_parser

## Usage

```ruby
require 'functional_parser'

P = FunctionalParser
p P.many(P.identifier).parse("hoge fuga piyo")
#=> #<FunctionalParser::Succeeded:0x007f86277d0a00 @parsed=["hoge", "fuga", "piyo"], @rest="">
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/functional_parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
