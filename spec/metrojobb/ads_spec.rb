RSpec.describe Metrojobb::Ads do
  it 'has ads > ad node' do
    ad = Metrojobb::Ad.new
    ads = Metrojobb::Ads.new([ad])
    xml = ads.to_xml

    expect(xml).to include('<ads>')
    expect(xml).to include('</ads>')
    expect(xml).to include('<ad orderno')
    expect(xml).to include('</ad>')
  end

  it 'has XML processing instructions' do
    ad = Metrojobb::Ad.new
    ads = Metrojobb::Ads.new([ad])
    xml = ads.to_xml

    expect(xml).to include('<?xml version="1.0" encoding="UTF-8"?>')
  end
end
