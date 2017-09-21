require 'active_model'

module Metrojobb
  class Contact < Model
    attr_accessor :name, :phone, :email

    def to_xml(builder: Builder::XmlMarkup.new(indent: DEFAULT_INDENT))
      builder.contact do |node|
        node.name { |n| n.cdata!(name.to_s) } if name.present?
        node.phone { |n| n.cdata!(phone.to_s) } if phone.present?
        node.email { |n| n.cdata!(email.to_s) } if email.present?
      end
    end
  end
end
