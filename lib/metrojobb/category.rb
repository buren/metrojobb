require 'csv'
require 'active_model'

module Metrojobb
  class Category < Model
    attr_accessor :id, :name

    NAME_ID_MAP = lambda {
      top_categories = {}

      data = CSV.read(
        File.expand_path('../../../data/categories.csv', __FILE__)
      ).map do |row|
        id, name = row
        if id.length < 3
          top_categories[id] = name
        else
          top_id = id[0..1]
          top_id = id[0] if id.length == 3
          top_name = top_categories[top_id]
          name = "#{top_name} > #{name}"
        end
        [id, name]
      end

      data.to_h.invert.freeze
    }.call

    ID_NAME_MAP = NAME_ID_MAP.invert.freeze

    validate :validate_known_category

    def self.names
      NAME_ID_MAP.keys
    end

    def self.ids
      NAME_ID_MAP.values
    end

    def self.name_id_map
      NAME_ID_MAP
    end

    def self.id_name_map
      NAME_ID_MAP.invert
    end

    def to_xml(builder: Builder::XmlMarkup.new(indent: DEFAULT_INDENT))
      builder.category do |node|
        node.id(category_id.to_s)
      end
    end

    def category_id
      self.class.name_id_map[name.presence || id.presence] ||
        id.presence ||
        name.presence
    end

    def validate_known_category
      return if self.class.id_name_map[category_id]

      errors.add(:category_id, :inclusion)
    end
  end
end
