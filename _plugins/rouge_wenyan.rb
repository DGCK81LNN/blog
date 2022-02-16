# -*- coding: utf-8 -*- #
# frozen_string_literal: true

require 'rouge'

module Rouge
  module Lexers
    class Wenyan < RegexLexer
      VERSION = '1.3.0'

      title 'Wenyan'
      desc "Programming language for the ancient Chinese (wy-lang.org)"
      tag 'wenyan'
      aliases 'wy', '文言'
      filenames '*.wy', '*.wenyan', '*.文言'

      KEYWORDS1 = %w[ 曰 有 者 今 噫 以 於 夫 若 也 遍 凡 施 取 豈 ]
      KEYWORDS2 = %w[
        書之 昔之 是矣 云云 若非 或若
        為是 乃止 是謂 乃得 之書 方悟 之義
        物之 嗚呼 之禍
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
      def comment_or(token)
        if in_state?(:comment) || in_state?(:comment_content) then Comment
        else token
        end
      end

      id = Javascript.id_regex

      start do
        @javascript = Javascript.new
      end

      state :root do
        mixin :whitespace
        mixin :simple_literals
        mixin :keywords
        mixin :string
        mixin :identifier

        # unrecognizable, may be macros
        rule /./, Text
      end

      state :whitespace do
        rule /\s+/, Text::Whitespace
        rule /[。、]/ do
          token comment_or(Punctuation)
        end
      end

      state :simple_literals do
        rule /[零一二三四五六七八九十百千萬億兆京垓秭穣穰溝澗正載極又分釐毫絲忽微纖沙塵埃渺漠〇]+/, Literal::Number
        rule /[陰陽]/, Literal
      end

      state :keywords do
        # special handling for some keywords
        rule /([吾今]有)(\s*)(一)(\s*)(術)/ do
          groups Keyword, Text, Literal::Number, Text, Keyword::Type
          push do
            mixin :whitespace
            rule /(名之曰)(\s*)(「)(\s*)(#{id})(\s*)(」)/ do
              groups Keyword, Text, Punctuation, Text, Name::Function, Text, Punctuation
            end
            rule(//) { pop! }
          end
        end
        rule %r/(是謂)(\s*)(「)(\s*)(#{id})(\s*)(」)(\s*)(之術也)/ do
          groups Keyword, Text, Punctuation, Text, Name::Function, Text, Punctuation, Text, Keyword
        end
        rule %r/(施|以施)(\s*)(「)(\s*)(#{id})(\s*)(」)/ do
          groups Keyword, Text, Punctuation, Text, Name::Function, Text, Punctuation
        end
        mixin :macro_definition
        rule /[注疏批]曰/, Comment, :comment

        # other keywords and operators
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
      end

      state :identifier do # mixin
        rule /(「)(\s*)(#{id})(\s*)(」)/ do
          groups Punctuation, Text, Name::Variable, Text, Punctuation
        end
        rule /「/ do
          token Punctuation
          @javascript.reset!
          @javascript.push(:expr_start)
          push do
            rule /[^」]+/ do
              delegate @javascript
            end
            rule /」/, Punctuation, :pop!
          end
        end
      end

      state :macro_definition do # mixin
        rule /或云|蓋謂/ do
          token Keyword
          push do
            rule /「「|『/ do
              token Str
              push :macro_definition_content
              push :macro_definition_content
            end
            rule // do
              pop!
            end
          end
        end
      end

      state :macro_definition_content do
        rule /[^『』「」]+/, Str
        rule /「[甲乙丙丁戊己庚辛壬癸]」/, Str::Escape
        rule /「/, Str, :macro_definition_content
        rule /」/, Str, :pop!
        rule /『/ do
          token Str
          push :macro_definition_content
          push :macro_definition_content
        end
        rule /』/ do
          pop!
          if state?(:macro_definition_content)
            pop!
            token Str
          else
            token Error
          end
        end
        rule /./m, Str
      end

      state :comment do
        mixin :whitespace
        rule /「「|『/ do
          token Comment
          goto :comment_content
          push :string_content
        end
      end

      state :comment_content do
        rule(//) { pop! }
      end

      state :string do # mixin
        rule /「「|『/ do
          token comment_or(Str)
          push :string_content
        end
      end

      state :string_content do
        rule /[^『』「」]+/ do
          token comment_or(Str)
        end
        rule /「「|『/ do
          token comment_or(Str::Escape)
          push :string_nested
        end
        rule /」{2,3}|』/ do
          token comment_or(Str)
          pop!
        end
        rule /./m do
          token comment_or(Str)
        end
      end

      state :string_nested do
        rule /[^『』「」]+/ do
          token comment_or(Str)
        end
        rule /「「|『/ do
          token comment_or(Str::Escape)
          push :string_nested
        end
        rule /」」|』/ do
          token comment_or(Str::Escape)
          pop!
        end
        rule /./m do
          token comment_or(Str)
        end
      end
    end
  end
end
