require 'date'
require 'active_model'

module Metrojobb
  class Ad < Model
    YYYY_MM_DD_REGEX = /\d{4}-\d{2}-\d{2}/

    INVALID_DATE_FORMAT_MSG = "must be in the following format: YYYY-MM-DD"
    TYPE_ERROR_MSG = 'unknown type'

    attr_accessor *[
      :order_number,
      :external_application,
      :heading,
      :job_title,
      :summary,
      :description,
      :employer,
      :employer_home_page,
      :opportunities,
      :from_date,
      :to_date,
      :external_logo_url,
      :application_url,
      :video_url,
      # relations
      :location,
      :contact,
      :employment_type,
      :category,
      :region
    ]

    validates :order_number, presence: true
    validates :heading, presence: true
    validates :job_title, presence: true
    validates :summary, presence: true
    validates :description, presence: true
    validates :location, presence: true
    validates :category, presence: true
    validates :region, presence: true

    validates_format_of :from_date, with: YYYY_MM_DD_REGEX, message: INVALID_DATE_FORMAT_MSG
    validates_format_of :to_date, with: YYYY_MM_DD_REGEX, message: INVALID_DATE_FORMAT_MSG

    validate :validate_location_type
    validate :validate_contact_type
    validate :validate_employment_type_type
    validate :validate_category_type
    validate :validate_region_type

    validate :validate_location_valid
    validate :validate_contact_valid
    validate :validate_employment_type_valid
    validate :validate_category_valid
    validate :validate_region_valid

    def to_xml(builder: Builder::XmlMarkup.new(indent: DEFAULT_INDENT))
      builder.ad(orderno: order_number) do |node|
        node.externalApplication(external_application)
        node.heading { |n| n.cdata!(heading.to_s) }
        node.jobTitle { |n| n.cdata!(job_title.to_s) }
        node.summary { |n| n.cdata!(summary.to_s) }
        node.description{ |n| n.cdata!(description.to_s) }
        node.employer{ |n| n.cdata!(employer.to_s) }
        node.employerHomePage{ |n| n.cdata!(employer_home_page.to_s) }
        node.opportunities{ |n| n.cdata!(opportunities.to_s) }
        node.fromdate(from_date)
        node.todate(to_date)
        node.externalLogoUrl{ |n| n.cdata!(external_logo_url.to_s) }
        node.applicationURL { |n| n.cdata!(application_url.to_s) }
        node.videoURL { |n| n.cdata!(video_url.to_s) }

        location.to_xml(builder: node) if location
        contact.to_xml(builder: node) if contact
        employment_type.to_xml(builder: node) if employment_type
        category.to_xml(builder: node) if category
        region.to_xml(builder: node) if region
      end
    end

    def validate_location_type
     return unless location
     return if location.is_a?(Location)

     errors.add(:location, TYPE_ERROR_MSG)
    end

    def validate_contact_type
     return unless contact
     return if contact.is_a?(Contact)

     errors.add(:contact, TYPE_ERROR_MSG)
    end

    def validate_employment_type_type
     return unless employment_type
     return if employment_type.is_a?(EmploymentType)

     errors.add(:employment_type, TYPE_ERROR_MSG)
    end

    def validate_category_type
     return unless category
     return if category.is_a?(Category)

     errors.add(:category, TYPE_ERROR_MSG)
    end

    def validate_region_type
     return unless region
     return if region.is_a?(Region)

     errors.add(:region, TYPE_ERROR_MSG)
    end

    def validate_location_valid
      return unless location.respond_to?(:valid?)
      return if location.valid?

      errors.add(:location, :invalid)
    end

    def validate_contact_valid
      return unless contact.respond_to?(:valid?)
      return if contact.valid?

      errors.add(:contact, :invalid)
    end

    def validate_employment_type_valid
      return unless employment_type.respond_to?(:valid?)
      return if employment_type.valid?

      errors.add(:employment_type, :invalid)
    end

    def validate_category_valid
      return unless category.respond_to?(:valid?)
      return if category.valid?

      errors.add(:category, :invalid)
    end

    def validate_region_valid
      return unless region.respond_to?(:valid?)
      return if region.valid?

      errors.add(:region, :invalid)
    end
  end
end
