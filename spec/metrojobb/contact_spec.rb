RSpec.describe Metrojobb::Contact do
  it 'can convert it self to XML' do
    contact = Metrojobb::Contact.new(name: 'buren', phone: '123')
    xml = contact.to_xml

    expect(xml).to include('<contact>')
    expect(xml).to include('<name>buren</name>')
    expect(xml).to include('<phone>123</phone>')
  end

  it 'retruns true when sent #valid?' do
    expect(Metrojobb::Contact.new.valid?).to eq(true)
  end
end
