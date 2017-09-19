require 'builder'

require 'metrojobb/version'
require 'metrojobb/ad'
require 'metrojobb/category'
require 'metrojobb/contact'
require 'metrojobb/employment_type'
require 'metrojobb/location'
require 'metrojobb/region'

module Metrojobb
  ORDER_NUMBER = '<<order_number>>'

  def self.build_ad(data, order_number: ORDER_NUMBER)
    builder = Builder::XmlMarkup.new(indent: 2)
    builder.ads do |ad_node|
      ad_node.ad(ordno: order_number)
      ad_node.ad(ordno: order_number)
    end
  end
end
