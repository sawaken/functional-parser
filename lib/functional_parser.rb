require "functional_parser/version"

class FunctionalParser
  class Succeeded
    attr_reader :parsed, :rest
    def initialize(parsed, rest)
      @parsed, @rest = parsed, rest
    end
  end

  class Failed
  end

  def initialize(&proc)
    @f = proc
  end

  def parse(inp)
    @f.call(inp)
  end

  def >>(proc)
    FunctionalParser.so(self, &proc)
  end

  def |(other)
    FunctionalParser.either(self, other)
  end

  def +(other)
    FunctionalParser.append(self, other)
  end

  def self.ret(something)
    new{|inp| Succeeded.new(something, inp)}
  end

  def self.failure
    new{|inp| Failed.new}
  end
  
  def self.item
    new{|inp| inp.size == 0 ? Failed.new : Succeeded.new(inp[0], inp[1, inp.size - 1])}
  end
  
  def self.so(parser, &proc)
    new{|inp|
      case result = parser.parse(inp)
      when Failed
        result
      when Succeeded
        proc.call(result.parsed).parse(result.rest)
      else
        raise "error."
      end
    }
  end

  def self.either(parser1, parser2)
    new{|inp|
      case result = parser1.parse(inp)
      when Failed
        parser2.parse(inp)
      when Succeeded
        result
      else
        raise "error."
      end
    }
  end

  def append(parser1, parser2)
    parser1 >> proc{|x|
      parer2 >> proc{|y|
        ret(x + y)
      }
    }
  end

  def self.sat(&proc)
    item >> proc{|c|
      proc.call(c) ? ret(c) : failure
    }
  end

  def self.digit
    sat{|c| "0" <= c && c <= "9"}
  end

  def self.lower
    sat{|c| "a" <= c && c <= "z"}
  end

  def self.upper
    sat{|c| "A" <= c && c <= "Z"}
  end

  def self.alpha
    lower | upper
  end

  def self.alphanum
    alpha | digit
  end

  def self.char(char)
    sat{|c| c == char}
  end

  def self.string(str)
    if str.size == 0
      ret(str)
    else
      char(str[0]) >> proc{|c|
        string(str[1, str.size - 1]) >> proc{
          ret(str)
        }
      }
    end
  end

  def self.many(parser)
    many1(parser) | ret([])
  end

  def self.many1(parser)
    parser >> proc{|x|
      many(parser) >> proc{|xs|
        ret([x] + xs)
      }
    }
  end

  def self.ident
    many1(alphanum) >> proc{|cs|
      ret(cs.inject(&:+))
    }
  end

  def self.nat
    many1(digit) >> proc{|cs|
      ret(cs.inject(&:+).to_i)
    }
  end

  def self.whitespace
    many(char("\s") | char("\n") | char("\t")) >> proc{
      ret(nil)
    }
  end

  def self.token(parser)
    whitespace >> proc{
      parser >> proc{|x|
        whitespace >> proc{
          ret(x)
        }
      }
    }
  end

  def self.identifier
    token(ident)
  end

  def self.natural
    token(nat)
  end
end

