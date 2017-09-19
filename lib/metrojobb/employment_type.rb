require 'active_model'

module Metrojobb
  class EmploymentType < Model
    attr_accessor :id, :name

    NAME_ID_MAP = CSV.read(
      File.expand_path('../../../data/employmenttypes.csv', __FILE__)
    ).to_h.invert.freeze

    ID_NAME_MAP = NAME_ID_MAP.invert.freeze

    validate :validate_known_employment_type

    def self.name_id_map
      NAME_ID_MAP
    end

    def self.id_name_map
      ID_NAME_MAP
    end

    def to_xml(builder: Builder::XmlMarkup.new(indent: DEFAULT_INDENT))
      builder.employmentType do |node|
        node.id(employment_type_id.to_s)
      end
    end

    def employment_type_id
      NAME_ID_MAP[name.presence || id.presence] ||
        id.presence ||
        name.presence
    end

    def validate_known_employment_type
      return if ID_NAME_MAP[employment_type_id]

      errors.add(:employment_type_id, :inclusion)
    end
  end
end
