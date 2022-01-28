# frozen_string_literal: true

module SoulBlog
  class TagPageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      tag_defs = site.data['tags']
      tag_docs = site.collections['tag_descriptions'].docs
      tag_defs.each do |tag_def|
        tag_name = tag_def['name']
        tag_slug = tag_def['slug']
        posts = site.tags[tag_name] || []

        doc = tag_docs.find { |doc| doc.basename_without_ext === tag_slug }
        desc = doc ? doc.content : nil

        site.pages << TagPage.new(site, tag_name, tag_slug, posts, desc)
      end
    end
  end

  class TagPage < Jekyll::Page
    def initialize(site, tag_name, tag_slug, posts, desc)
      super(site, site.source, '_tag_descriptions', '_template.html')

      @tag_slug = tag_slug
      @tag_name = tag_name
      @posts = posts
      @desc = desc

      @data['tag_name'] = tag_name
      @data['posts'] = posts
      @data['description'] = desc
      @data['title'] = "标签：#{tag_name}"
    end

    def type
      :tag_pages
    end

    def url_placeholders
      {
        title: @tag_name,
        slug: @tag_slug
      }
    end
  end
end

