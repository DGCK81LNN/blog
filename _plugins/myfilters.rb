# frozen_string_literal: true

require 'digest/md5'

module SoulBlog
  module Filters
    def soulblog_gravatar(email)
      base = "https://gravatar.loli.net/avatar/"
      if email && !email.empty?
        hash = Digest::MD5.hexdigest(email.downcase)
        "#{base}#{hash}?d=identicon"
      else
        "#{base}?f=y&d=mp"
      end
    end

    def soulblog_emailsub(input)
      input.gsub(/[@._-]/, {
        "@" => " at ",
        "." => " dot ",
        "_" => " underscore ",
        "-" => " dash ",
      })
    end
  end
end

Liquid::Template.register_filter(SoulBlog::Filters)

