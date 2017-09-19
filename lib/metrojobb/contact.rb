require 'active_model'

module Metrojobb
  class Contact < Model
    attr_accessor :name, :phone, :email

    def to_xml(builder: Builder::XmlMarkup.new(indent: DEFAULT_INDENT))
      builder.contact do |node|
        node.name { |n| n.cdata!(name.to_s) }
        node.phone { |n| n.cdata!(phone.to_s) }
        node.email { |n| n.cdata!(email.to_s) }
      end
    end
  end
end
