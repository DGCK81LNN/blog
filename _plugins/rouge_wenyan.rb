# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'rouge'

module Rouge
  module Lexers
    class Wenyan < RegexLexer
      title 'Wenyan'
      desc "Programming language for the ancient Chinese (wy-lang.org)"
      tag 'wenyan'
      aliases 'wy', '文言'
      filenames '*.wy', '*.wenyan', '*.文言'

      KEYWORDS1 = %w[ 曰 有 者 今 噫 以 於 夫 若 也 遍 凡 施 取 豈 ]
      KEYWORDS2 = %w[
        書之 昔之 是矣 云云 若非 或若
        為是 乃止 是謂 乃得 之書 方悟 之義
        物之 嗚呼 之禍 或云 蓋謂
      ]
      KEYWORDS3 = %w[
        名之曰 恆為是 是術曰 必先得
        之術也 之物也 吾嘗觀 之禍歟 乃作罷
      ]
      KEYWORDS4 = %w[
        若其然者 乃止是遍 欲行是術 乃歸空無
        其物如是 姑妄行此 如事不諧
      ]
      KEYWORDS5 = %w[ 若其不然者 乃行是術曰 不知何禍歟 ]
      TYPES = %w[ 數 言 爻 列 術 物 元 ]
      OPERATORS1 = %w[ 加 減 乘 除 變 充 銜 之 ]
      OPERATORS2 = %w[ 等於 大於 小於 之長 中之 ]
      OPERATORS3 = %w[ 不等於 不大於 不小於 之其餘 ]
      OPERATORS4 = %w[ 所餘幾何 中有陽乎 中無陰乎 ]

      private

      def token_str
        if in_state?(:comment) then Comment
        else Str
        end
      end

      def token_str_escape
        if in_state?(:comment) then Comment
        else Str::Escape
        end
      end

      state :whitespace do
        rule /\s+/, Text::Whitespace
        rule /[。、]/ do
          if in_state?(:comment)
            token Comment
          else
            token Punctuation
          end
        end
      end

      state :root do
        mixin :whitespace
        mixin :string
        mixin :variable_name

        rule /[零一二三四五六七八九十百千萬億兆京垓秭穣穰溝澗正載極又分釐毫絲忽微纖沙塵埃渺漠〇]+/, Literal::Number
        rule /[陰陽]/, Literal

        # special handling for function names
        rule /([吾今]有)(一)(術)/ do
          groups Keyword, Literal::Number, Keyword::Type
          push :maybe_function_definition
        end
        rule /(施|以施)(「[^」]*」)/ do
          groups Keyword, Name::Function
        end
        rule /(是謂)(「[^」]*」)(之術也)/ do
          groups Keyword, Name::Function, Keyword
        end

        # keywords and operators
        rule Regexp.new(KEYWORDS5.join('|')), Keyword
        rule Regexp.new(KEYWORDS4.join('|')), Keyword
        rule Regexp.new(OPERATORS4.join('|')), Operator
        rule Regexp.new(KEYWORDS3.join('|')), Keyword
        rule Regexp.new(OPERATORS3.join('|')), Operator
        rule Regexp.new(KEYWORDS2.join('|')), Keyword
        rule Regexp.new(OPERATORS2.join('|')), Operator
        rule /[吾今]有/, Keyword::Declaration
        rule Regexp.new(KEYWORDS1.join('|')), Keyword
        rule Regexp.new(TYPES.join('|')), Keyword::Type
        rule Regexp.new(OPERATORS1.join('|')), Operator
        rule /其/, Keyword::Constant
        rule /[注疏批]曰/, Comment, :comment

        # unrecognizable, may be macros
        rule /./, Text
      end

      state :variable_name do # mixin
        rule /「[^」]*」/, Name::Variable
      end

      state :maybe_function_definition do
        mixin :whitespace
        rule /(名之曰)(「[^」]*」)/ do
          groups Keyword, Name::Function
        end
        rule // do
          pop!
        end
      end

      state :comment do
        mixin :whitespace
        mixin :string
        rule // do
          pop!
        end
      end

      state :string do # mixin
        rule /「「/ do
          token token_str
          push :string_double
        end
        rule /『/ do
          token token_str
          push :string_hollow
        end
      end

      state :string_double do
        rule /」{2,3}/ do
          token token_str
          pop!
        end
        mixin :string_content
      end

      state :string_hollow do
        rule /』/ do
          token token_str
          pop!
        end
        mixin :string_content
      end

      state :string_content do # mixin
        rule /[^『』「」]+/ do
          token token_str
        end
        rule /「「/ do
          token token_str_escape
          push :string_nested
        end
        rule /『/ do
          token token_str_escape
          push :string_nested
        end
        rule /./m do
          token token_str
        end
      end

      state :string_nested do
        rule /」」/ do
          token token_str_escape
          pop!
        end
        rule /』/ do
          token token_str_escape
          pop!
        end
        mixin :string_content
      end
    end
  end
end
