# frozen_string_literal: true

require 'digest/md5'

class Gravatar < Liquid::Tag
  def initialize(_tag_name, text, _tokens)
    super
    @text = text.strip.downcase
    @text = nil if @text.empty?
  end
  def render(_context)
    base = "https://gravatar.loli.net/avatar/"
    if @text
      hash = Digest::MD5.hexdigest(@text)
      "#{base}#{hash}?d=identicon"
    else
      "#{base}?f=y&d=mp"
    end
  end
end

Liquid::Template.register_tag('soulblog_gravatar', Gravatar)
