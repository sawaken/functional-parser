require 'functional_parser'

class SchemeParser < FunctionalParser


  def self.ident
    head_char >> proc{|head|
      many(suc_char) >> proc{|tail|
        ret(:kind => :ident, :data => head + tail.inject("", &:+))
      }} | peculiar_ident
  end

  def self.head_char
    alpha | sp_head_alpha
  end

  def self.sp_head_alpha
    "!$%&*/:<=>?^_~".chars.map{|c| char(c)}.inject(&:|)
  end

  def self.suc_char
    head_char | digit | sp_suc_char
  end

  def self.sp_suc_char
    "+-.@".chars.map{|c| char(c)}.inject(&:|)
  end

  def self.peculiar_ident
    char("+") | char ("-") | string("...")
  end
end

