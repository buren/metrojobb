require 'active_model'

module Metrojobb
  class Contact
    include ActiveModel::Model

    attr_accessor :name, :phone, :email

    def to_xml(builder: Builder::XmlMarkup.new(indent: 2))
      builder.contact do |node|
        node.name(name) if name.present?
        node.phone(phone) if phone.present?
        node.email(email) if email.present?
      end
    end
  end
end
