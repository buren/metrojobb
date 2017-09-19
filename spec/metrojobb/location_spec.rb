RSpec.describe Metrojobb::Location do
  it 'can convert it self to XML' do
    location = Metrojobb::Location.new(
      street: 'abc street',
      postal_code: '123',
      city: 'Stockholm'
    )
    xml = location.to_xml

    expect(xml).to include('<location>')
    expect(xml).to include('<street><![CDATA[abc street]]></street>')
    expect(xml).to include('<postalCode><![CDATA[123]]></postalCode>')
    expect(xml).to include('<city><![CDATA[Stockholm]]></city>')
  end

  it 'has #valid? method' do
    expect(Metrojobb::Location.new.valid?).to eq(true)
  end
end
