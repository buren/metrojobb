require 'active_model'

module Metrojobb
  class EmploymentType < Model
    attr_accessor :id, :name

    NAME_ID_MAP = CSV.read(
      File.expand_path('../../../data/employmenttypes.csv', __FILE__)
    ).to_h.invert.freeze

    validate :validate_known_employment_type

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
      builder.employmentType do |node|
        node.id(employment_type_id.to_s)
      end
    end

    def employment_type_id
      self.class.name_id_map[name.presence || id.presence] ||
        id.presence ||
        name.presence
    end

    def validate_known_employment_type
      return if self.class.id_name_map[employment_type_id]

      errors.add(:employment_type_id, :inclusion)
    end
  end
end
