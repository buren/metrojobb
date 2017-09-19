RSpec.describe Metrojobb::Region do
  describe '#to_xml!' do
    it 'raises InvalidModelError if invalid' do
      ad = Metrojobb::Region.new
      ad.validate

      expect do
        ad.to_xml!
      end.to raise_error(Metrojobb::Model::InvalidError)
    end
  end

  it 'can convert it self to XML' do
    contact = Metrojobb::Region.new(name: 'Stockholms län')
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
      type = Metrojobb::Region.new(name: 'Stockholms län')
      type.validate_known_region

      expect(type.errors[:region_id]).not_to include('is not included in the list')
    end
  end

  describe '#region_id' do
    [
      # input, expected
      ['Gotlands län', '9'],
      ['9', '9'],
      ['Motala', '583'],
      ['Tomelilla', '1270'],
      ['Sverige', '10001'],
      ['Østfold', '12300'],
      ['Saint Martin (franska delen)', '14235'],
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
