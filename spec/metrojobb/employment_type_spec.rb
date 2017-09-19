RSpec.describe Metrojobb::EmploymentType do
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
    it 'adds error on #metrojobb_id' do
      type = Metrojobb::EmploymentType.new
      type.validate_known_employment_type

      expect(type.errors[:metrojobb_id]).to include('is not included in the list')
    end

    it 'adds no error on #metrojobb_id' do
      type = Metrojobb::EmploymentType.new(name: 'Heltid')
      type.validate_known_employment_type

      expect(type.errors[:metrojobb_id]).not_to include('is not included in the list')
    end
  end

  describe '#metrojobb_id' do
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
        expect(type.metrojobb_id).to eq(expected)
      end

      it "returns #{expected} when given #{input} as the name" do
        type = Metrojobb::EmploymentType.new(name: input)
        expect(type.metrojobb_id).to eq(expected)
      end

      it "returns #{expected} when given #{input} as the name and id" do
        type = Metrojobb::EmploymentType.new(id: input, name: input)
        expect(type.metrojobb_id).to eq(expected)
      end
    end
  end
end
