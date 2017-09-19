require 'active_model'

module Metrojobb
  class Region < Model
    attr_accessor :id, :name

    NAME_ID_MAP = CSV.read(
      File.expand_path('../../../data/regions.csv', __FILE__)
    ).to_h.invert.freeze

    validate :validate_known_region

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
      builder.region do |node|
        node.id(region_id.to_s)
      end
    end

    def region_id
      self.class.name_id_map[name.presence || id.presence] ||
        id.presence ||
        name.presence
    end

    def validate_known_region
      return if self.class.id_name_map[region_id]

      errors.add(:region_id, :inclusion)
    end
  end
end
