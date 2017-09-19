module Metrojobb
  class Ads
    attr_reader :ads

    def initialize(ads)
      @ads = ads
    end

    def to_xml
      builder = Builder::XmlMarkup.new(indent: DEFAULT_INDENT)
      builder.instruct!(:xml, version: '1.0', encoding: 'UTF-8')
      builder.ads do |node|
        ads.each { |ad| ad.to_xml(builder: builder) }
      end
    end
  end
end
