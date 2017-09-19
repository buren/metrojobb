RSpec.describe Metrojobb::EmploymentType do
  describe '#to_xml!' do
    it 'raises InvalidModelError if invalid' do
      ad = Metrojobb::EmploymentType.new
      ad.validate

      expect do
        ad.to_xml!
      end.to raise_error(Metrojobb::Model::InvalidError)
    end
  end

  it 'can convert it self to XML' do
    contact = Metrojobb::EmploymentType.new(name: 'Heltid')
    xml = contact.to_xml

    expect(xml).to include('<employmentType>')
    expect(xml).to include('<id>1</id>')
  end

  describe '#valid?' do
    it 'retruns false when invalid' do
      expect(Metrojobb::EmploymentType.new.valid?).to eq(false)
    end
  end

  describe '#validate_known_employment_type' do
    it 'adds error on #employment_type_id' do
      type = Metrojobb::EmploymentType.new
      type.validate_known_employment_type

      expect(type.errors[:employment_type_id]).to include('is not included in the list')
    end

    it 'adds no error on #employment_type_id' do
      type = Metrojobb::EmploymentType.new(name: 'Heltid')
      type.validate_known_employment_type

      expect(type.errors[:employment_type_id]).not_to include('is not included in the list')
    end
  end

  describe '#employment_type_id' do
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
        type = Metrojobb::EmploymentType.new(id: input)
        expect(type.employment_type_id).to eq(expected)
      end

      it "returns #{expected} when given #{input} as the name" do
        type = Metrojobb::EmploymentType.new(name: input)
        expect(type.employment_type_id).to eq(expected)
      end

      it "returns #{expected} when given #{input} as the name and id" do
        type = Metrojobb::EmploymentType.new(id: input, name: input)
        expect(type.employment_type_id).to eq(expected)
      end
    end
  end
end
