# frozen_string_literal: true

require 'base64'

module SoulBlog
  module Filters
    def soulblog_base64(str)
      Base64.strict_encode64(str)
    end
  end
end

Liquid::Template.register_filter(SoulBlog::Filters)

