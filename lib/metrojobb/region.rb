require 'active_model'

module Metrojobb
  class Region < Model
    attr_accessor :id, :name

    NAME_ID_MAP = CSV.read(
      File.expand_path('../../../data/regions.csv', __FILE__)
    ).to_h.invert.freeze

    ID_NAME_MAP = NAME_ID_MAP.invert.freeze

    validate :validate_known_region

    def to_xml(builder: Builder::XmlMarkup.new(indent: DEFAULT_INDENT))
      builder.region do |node|
        node.id(region_id.to_s)
      end
    end

    def region_id
      NAME_ID_MAP[name.presence || id.presence] ||
        id.presence ||
        name.presence
    end

    def validate_known_region
      return if ID_NAME_MAP[region_id]

      errors.add(:region_id, :inclusion)
    end
  end
end
