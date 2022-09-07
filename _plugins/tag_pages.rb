# frozen_string_literal: true

module SoulBlog
  class TagPageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      tag_defs = site.data['tags']
      tag_docs = site.collections['tags'].docs
      tag_defs.each do |tag_def|
        tag_name = tag_def['name']
        tag_slug = tag_def['slug']
        posts = site.tags[tag_name]
        next if posts.nil? || posts.empty?

        doc = tag_docs.find { |doc| doc.basename_without_ext === tag_slug }

        site.pages << TagPage.new(site, tag_name, tag_slug, posts, doc)
      end
    end
  end

  class TagPage < Jekyll::Page
    def initialize(site, tag_name, tag_slug, posts, doc)
      @site = site
      @base = site.source
      @dir  = '_tags'
      @name = doc ? doc.basename : "#{tag_slug}.md"
      @path = site.in_source_dir(@base, @dir, @name)
      @tag_slug = tag_slug
      @tag_name = tag_name

      process(name)
      if doc
        read_yaml(Jekyll::PathManager.join(@base, @dir), @name)
      else
        @data = {}
      end
      @data['title'] ||= "标签：#{tag_name}"
      @data['layout'] ||= "tags"
      @data['posts'] ||= posts
      @data['tag_name'] = tag_name

      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, type, key)
      end

      Jekyll::Hooks.trigger :pages, :post_init, self
    end

    def type
      :tags
    end

    def url_placeholders
      {
        title: @tag_name,
        slug: @tag_slug,
        output_ext: output_ext,
      }
    end

    def template
      "/tags/:slug"
    end
  end
end
