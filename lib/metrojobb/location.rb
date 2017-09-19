require 'active_model'

module Metrojobb
  class Location
    include ActiveModel::Model

    attr_accessor :street, :postal_code, :city

    def to_xml(builder: Builder::XmlMarkup.new(indent: 2))
      builder.location do |node|
        node.street(street) if street.present?
        node.postalCode(postal_code) if postal_code.present?
        node.city(city) if city.present?
      end
    end
  end
end
