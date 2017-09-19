require 'csv'
require 'active_model'

module Metrojobb
  class Category < Model
    attr_accessor :id, :name

    NAME_ID_MAP = CSV.read(
      File.expand_path('../../../data/categories.csv', __FILE__)
    ).to_h.invert.freeze

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
