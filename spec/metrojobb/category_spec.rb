RSpec.describe Metrojobb::Category do
  it 'can convert it self to XML' do
    contact = Metrojobb::Category.new(name: 'Administration')
    xml = contact.to_xml

    expect(xml).to include('<category>')
    expect(xml).to include('<id>1800</id>')
  end

  describe '#valid?' do
    it 'retruns false when invalid' do
      expect(Metrojobb::Category.new.valid?).to eq(false)
    end
  end

  describe '#validate_known_category' do
    it 'adds error on #category_id' do
      type = Metrojobb::Category.new
      type.validate_known_category

      expect(type.errors[:category_id]).to include('is not included in the list')
    end

    it 'adds no error on #category_id' do
      type = Metrojobb::Category.new(name: 'Administration')
      type.validate_known_category

      expect(type.errors[:category_id]).not_to include('is not included in the list')
    end
  end

  describe '#category_id' do
    [
      # input, expected
      ['Administration', '1800'], # NOTE: There is a duplicate in the raw data (row 1 and 1805)
      ['1800', '1800'],
      ['Data / IT', '1802'], # NOTE: There is a duplicate in the raw data (row 3 and 1802)
      ['1802', '1802'],
      ['Utvecklare / Programmerare', '305'],
      ['305', '305'],
      ['Apotekare / Farmaceutisk rådgivare', '1901'],
      # bad data
      [nil, nil],
      ['111111111', '111111111'],
      ['abc', 'abc']
    ].each do |data|
      input, expected = data

      it "returns #{expected} when given #{input} as the id" do
        type = Metrojobb::Category.new(id: input)
        expect(type.category_id).to eq(expected)
      end

      it "returns #{expected} when given #{input} as the name" do
        type = Metrojobb::Category.new(name: input)
        expect(type.category_id).to eq(expected)
      end

      it "returns #{expected} when given #{input} as the name and id" do
        type = Metrojobb::Category.new(id: input, name: input)
        expect(type.category_id).to eq(expected)
      end
    end
  end
end
