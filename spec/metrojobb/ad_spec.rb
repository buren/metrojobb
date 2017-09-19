RSpec.describe Metrojobb::Ad do
  describe '#to_xml!' do
    it 'raises InvalidModelError if invalid' do
      ad = Metrojobb::Ad.new
      ad.validate

      expect do
        ad.to_xml!
      end.to raise_error(Metrojobb::Model::InvalidError)
    end
  end

  describe '#to_xml' do
    [
      # attribute, node_name, value, cdata
      [:external_application, 'externalApplication', 'watman', false],
      [:heading, 'heading', 'watman', true],
      [:job_title, 'jobTitle', 'watman', true],
      [:summary, 'summary', 'watman', true],
      [:description, 'description', 'watman', true],
      [:employer, 'employer', 'watman', true],
      [:employer_home_page, 'employerHomePage', 'http://exmple.com', true],
      [:opportunities, 'opportunities', 'watman', true],
      [:from_date, 'fromdate', '2018-09-01', false],
      [:to_date, 'todate', '2018-09-01', false],
      [:external_logo_url, 'externalLogoUrl', 'http://exmple.com', true],
      [:application_url, 'applicationURL', 'http://exmple.com', true]
    ].each do |data|
      attribute, node_name, value, cdata = data

      it "includes #{node_name} node_name and value" do
        ad = Metrojobb::Ad.new(attribute => value)
        xml = ad.to_xml

        if cdata
          expect(xml).to include("<#{node_name}><![CDATA[#{value}]]></#{node_name}>")
        else
          expect(xml).to include("<#{node_name}>#{value}</#{node_name}>")
        end
      end
    end

    it 'has correct orderno attribute on ad node' do
      ad = Metrojobb::Ad.new(order_number: 'order_number_value')
      xml = ad.to_xml

      expect(xml).to include("<ad orderno=\"order_number_value\"")
    end

    [
      [:location, 'location', Metrojobb::Location.new(city: 'Stockholm')],
      [:contact, 'contact', Metrojobb::Contact.new(name: 'buren')],
      [:employment_type, 'employmentType', Metrojobb::EmploymentType.new(id: '1')],
      [:category, 'category', Metrojobb::Category.new(id: '1')],
      [:region, 'region', Metrojobb::Region.new(id: '1')]
    ].each do |data|
      attribute, node_name, value = data

      it "includes #{node_name}" do
        ad = Metrojobb::Ad.new(attribute => value)
        xml = ad.to_xml

        expect(xml).to include("<#{node_name}>")
      end
    end
  end

  describe '#validate' do
    %i[
      order_number
      heading
      job_title
      summary
      description
      location
      category
      region
    ].each do |attribute|
      it "validates presence of #{attribute}" do
        ad = Metrojobb::Ad.new
        ad.validate

        expect(ad.errors[attribute]).to include("can't be blank")
      end
    end

    [
      :from_date,
      :to_date
    ].each do |data|
      attribute = data

      it "adds error if #{attribute} is an invalid date" do
        ad = Metrojobb::Ad.new(attribute => 'asdkl')
        ad.validate

        error_message = Metrojobb::Ad::INVALID_DATE_FORMAT_MSG
        expect(ad.errors[attribute]).to include(error_message)
      end

      it "does not add error if #{attribute} is an valid date" do
        ad = Metrojobb::Ad.new(attribute => '2018-09-01')
        ad.validate

        error_message = Metrojobb::Ad::INVALID_DATE_FORMAT_MSG
        expect(ad.errors[attribute]).not_to include(error_message)
      end
    end

    [
      # attribute, value
      [:location, Metrojobb::Location.new],
      [:contact, Metrojobb::Contact.new],
      [:employment_type, Metrojobb::EmploymentType.new],
      [:category, Metrojobb::Category.new],
      [:region, Metrojobb::Region.new]
    ].each do |data|
      attribute, relation = data

      it 'does not add unknown type error if attribute is of unknown type' do
        ad = Metrojobb::Ad.new(attribute => relation)
        ad.validate

        expect(ad.errors[attribute]).not_to include(Metrojobb::Ad::TYPE_ERROR_MSG)
      end

      it 'adds unknown type error if attribute is of unknown type' do
        ad = Metrojobb::Ad.new(attribute => 'value')
        ad.validate

        expect(ad.errors[attribute]).to include(Metrojobb::Ad::TYPE_ERROR_MSG)
      end

      # location and contact models can't be invalid
      unless attribute == :location || attribute == :contact
        it "adds invalid error if #{attribute} is not valid" do
          ad = Metrojobb::Ad.new(attribute => relation)
          ad.validate

          expect(ad.errors[attribute]).to include('is invalid')
        end
      end
    end
  end
end
