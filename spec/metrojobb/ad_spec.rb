RSpec.describe Metrojobb::Ad do
  describe '#to_xml' do
    [
      [:external_application, 'externalApplication', 'externalapplication'],
      [:heading, 'heading', 'heading'],
      [:job_title, 'jobTitle', 'jobtitle'],
      [:summary, 'summary', 'summary'],
      [:description, 'description', 'description'],
      [:employer, 'employer', 'employer'],
      [:employer_home_page, 'employerHomePage', 'employerhomepage'],
      [:opportunities, 'opportunities', 'opportunities'],
      [:from_date, 'fromdate', 'fromdate'],
      [:to_date, 'todate', 'todate'],
      [:external_logo_url, 'externalLogoUrl', 'externallogourl'],
      [:application_url, 'applicationURL', 'applicationurl']
    ].each do |data|
      attribute, node_name, value = data

      it "includes #{node_name} node_name and value" do
        ad = Metrojobb::Ad.new(attribute => value)
        xml = ad.to_xml

        expect(xml).to include("<#{node_name}>#{value}</#{node_name}>")
      end
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
    end
  end
end
