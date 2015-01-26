$LIBRARY_ROOT_PATH = File.dirname(File.expand_path(File.dirname(__FILE__)))

class FunctionalParser
  module UnitTest
    require 'test/unit'
    require $LIBRARY_ROOT_PATH + '/lib/functional_parser.rb'

    class FunctionalParserTest < Test::Unit::TestCase

      P = FunctionalParser

      def test_ret
        result = P.ret("hoge").parse("fuga")
        assert_kind_of(Succeeded, result)
        assert_equal("hoge", result.parsed)
        assert_equal("fuga", result.rest)
      end

      def test_failure
        assert_kind_of(Failed, P.failure.parse("hoge"))
      end

      def test_item_suc
        result = P.item.parse("hoge")
        assert_kind_of(Succeeded, result)
        assert_equal("h", result.parsed)
        assert_equal("oge", result.rest)
      end

      def test_item_fai
        assert_kind_of(Failed, P.item.parse(""))
      end

      def test_so_suc
        result = P.so(P.item){|c| P.ret(c.next)}.parse("hoge")
        assert_kind_of(Succeeded, result)
        assert_equal("i", result.parsed)
        assert_equal("oge", result.rest)
      end

      def test_so_fai
        assert_kind_of(Failed, P.so(P.item){|c| P.ret(c.next)}.parse(""))
      end

      def test_either_suc_suc
        result = P.either(P.ret("a"), P.ret("b")).parse("hoge")
        assert_kind_of(Succeeded, result)
        assert_equal("a", result.parsed)
        assert_equal("hoge", result.rest)
      end

      def test_either_suc_fai
        result = P.either(P.ret("a"), P.failure).parse("hoge")
        assert_kind_of(Succeeded, result)
        assert_equal("a", result.parsed)
        assert_equal("hoge", result.rest)
      end

      def test_either_fai_suc
        result = P.either(P.failure, P.ret("b")).parse("hoge")
        assert_kind_of(Succeeded, result)
        assert_equal("b", result.parsed)
        assert_equal("hoge", result.rest)
      end

      def test_either_fai_fai
        result = P.either(P.failure, P.failure).parse("hoge")
        assert_kind_of(Failed, result)
      end

      def test_append_suc_suc
        result = P.append(P.ret("a"), P.ret("b")).parse("hoge")
        assert_kind_of(Succeeded, result)
        assert_equal("ab", result.parsed)
        assert_equal("hoge", result.rest)
      end

      def test_append_suc_fai
        assert_kind_of(Failed, P.append(P.ret("a"), P.failure).parse("hoge"))
      end

      def test_append_fai_suc
        assert_kind_of(Failed, P.append(P.failure, P.ret("b")).parse("hoge"))
      end

      def test_append_fai_fai
        assert_kind_of(Failed, P.append(P.failure, P.failure).parse("hoge"))
      end

      def test_sat_suc
        result = P.sat{|c| c == "a"}.parse("age")
        assert_kind_of(Succeeded, result)
        assert_equal("a", result.parsed)
        assert_equal("ge", result.rest)
      end

      def test_sat_fai
        assert_kind_of(Failed, P.sat{|c| c == "a"}.parse("sage"))
      end

      def test_string_suc
        result = P.string("ho").parse("hoge")
        assert_kind_of(Succeeded, result)
        assert_equal("ho", result.parsed)
        assert_equal("ge", result.rest)
      end

      def test_string_fai
        assert_kind_of(Failed, P.string("ho").parse("hage"))
      end

      def test_many
        result = P.many(P.string("hoge")).parse("hogehogefuga")
        assert_kind_of(Succeeded, result)
        assert_equal(["hoge", "hoge"], result.parsed)
        assert_equal("fuga", result.rest)
      end

      def test_many_0times
        result = P.many(P.string("hoge")).parse("fugafugafuga")
        assert_kind_of(Succeeded, result)
        assert_equal([], result.parsed)
        assert_equal("fugafugafuga", result.rest)
      end
    end
  end
end
