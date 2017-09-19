require 'active_model'

module Metrojobb
  class Location < Model
    attr_accessor :street, :postal_code, :city

    def to_xml(builder: Builder::XmlMarkup.new(indent: DEFAULT_INDENT))
      builder.location do |node|
        node.street { |n| n.cdata!(street.to_s) }
        node.postalCode { |n| n.cdata!(postal_code.to_s) }
        node.city { |n| n.cdata!(city.to_s) }
      end
    end
  end
end
