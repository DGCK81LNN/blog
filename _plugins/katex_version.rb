# frozen_string_literal: true
require "katex"

Jekyll::Hooks.register(:site, :after_init) do |site|
  site.config["katex_version"] = Katex::KATEX_VERSION.sub(/^v/, "")
end
