# frozen_string_literal: true

Jekyll::Hooks.register(:documents, :post_init) do |doc|
  if (doc.collection.label === "diary_entries")
    path = doc.relative_path.split('/')
    pos = path.index('_diary_entries')
    if pos
      categories = path[pos + 1 .. -2]
      doc.merge_data!({ "categories" => categories }, source: "file path")
    end
  end
end
