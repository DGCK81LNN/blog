# frozen_string_literal: true

require 'digest/md5'
require 'base64'

module SoulBlog
  module Filters
    def soulblog_md5(str)
      Digest::MD5.hexdigest(str)
    end

    def soulblog_emailsub(input)
      input.gsub(/[@._-]/, {
        "@" => " at ",
        "." => " dot ",
        "_" => " underscore ",
        "-" => " dash ",
      })
    end

    def soulblog_base64(str)
      Base64.strict_encode64(str)
    end
  end
end

Liquid::Template.register_filter(SoulBlog::Filters)

