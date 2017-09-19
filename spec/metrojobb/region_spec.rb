RSpec.describe Metrojobb::Region do
  it 'can convert it self to XML' do
    contact = Metrojobb::Region.new(name: 'Heltid')
    xml = contact.to_xml

    expect(xml).to include('<region>')
    expect(xml).to include('<id>1</id>')
  end

  describe '#valid?' do
    it 'retruns false when invalid' do
      expect(Metrojobb::Region.new.valid?).to eq(false)
    end
  end

  describe '#validate_known_region' do
    it 'adds error on #region_id' do
      type = Metrojobb::Region.new
      type.validate_known_region

      expect(type.errors[:region_id]).to include('is not included in the list')
    end

    it 'adds no error on #region_id' do
      type = Metrojobb::Region.new(name: 'Heltid')
      type.validate_known_region

      expect(type.errors[:region_id]).not_to include('is not included in the list')
    end
  end

  describe '#region_id' do
    [
      # input, expected
      ['Heltid', '1'],
      ['1', '1'],
      ['Deltid', '2'],
      ['2', '2'],
      ['Vikariat', '3'],
      ['3', '3'],
      ['Extra / Säsong / Visstid', '4'],
      ['4', '4'],
      # bad data
      [nil, nil],
      ['1111', '1111'],
      ['abc', 'abc']
    ].each do |data|
      input, expected = data

      it "returns #{expected} when given #{input} as the id" do
        type = Metrojobb::Region.new(id: input)
        expect(type.region_id).to eq(expected)
      end

      it "returns #{expected} when given #{input} as the name" do
        type = Metrojobb::Region.new(name: input)
        expect(type.region_id).to eq(expected)
      end

      it "returns #{expected} when given #{input} as the name and id" do
        type = Metrojobb::Region.new(id: input, name: input)
        expect(type.region_id).to eq(expected)
      end
    end
  end
end
