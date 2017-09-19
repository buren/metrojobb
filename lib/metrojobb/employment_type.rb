require 'active_model'

module Metrojobb
  class EmploymentType < Model
    attr_accessor :id, :name

    NAME_ID_MAP = CSV.read(
      File.expand_path('../../../data/employmenttypes.csv', __FILE__)
    ).to_h.invert.freeze

    ID_NAME_MAP = NAME_ID_MAP.invert.freeze

    validate :validate_known_employment_type

    def to_xml(builder: Builder::XmlMarkup.new(indent: 2))
      builder.employmentType do |node|
        node.id(metrojobb_id)
      end
    end

    def metrojobb_id
      NAME_ID_MAP[name.presence || id.presence] ||
        id.presence ||
        name.presence
    end

    def validate_known_employment_type
      return if ID_NAME_MAP[metrojobb_id]

      errors.add(:metrojobb_id, :inclusion)
    end
  end
end
