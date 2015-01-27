# FunctionalParser

Yet another functional text-parsing library by Ruby.

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


example1
```ruby
require 'functional_parser'

P = FunctionalParser
p P.many(P.identifier).parse("hoge fuga piyo")
#=> #<FunctionalParser::Succeeded:0x007f86277d0a00
#      @parsed=["hoge", "fuga", "piyo"],
#      @rest="">
```


example2
```ruby
require 'functional_parser'

P = FunctionalParser

option_key = P.whitespace >> proc{
  P.string("--") >> proc{
    P.ident >> proc{|key|
      P.whitespace >> proc{
        P.ret(key)
      }}}}

option_value = P.many(P.identifier)

option_key_value = option_key >> proc{|key|
  option_value >> proc{|values|
    P.ret({key => values})
  }}
        

options = P.many(option_key_value) >> proc{|hs|
  P.ret(hs.inject{|a, b| a.merge(b)})
}

p options.parse("--option1 --option2 value1 value2 --option3")
#=> #<FunctionalParser::Succeeded:0x007fc5fc280900
#      @parsed={"option1"=>[], "option2"=>["value1", "value2"], "option3"=>[]},
#      @rest="">
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/functional_parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
