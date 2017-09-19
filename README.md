# Metrojobb

Build a feed for Metrojobb with ease.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'metrojobb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install metrojobb

## Usage

:information_source: For detailed usage please see the test suite in `spec/`.

__Examples__

Single model

```ruby
region = Metrojobb::Region.new(name: 'Stockholms län')
region.valid? # => true
region.errors[:region_id] # => []
region.to_xml # => '<region><id>1</id></region>'
```

Single model with errors

```ruby
region = Metrojobb::Region.new(id: 'invalid id')
region.valid? # => false
region.errors[:region_id] # => ["is not included in the list"]
```

All values and relations:

```ruby
ad = Metrojobb::Ad.new(
  external_application: nil,
  heading: nil,
  job_title: nil,
  summary: nil,
  description: nil,
  employer: nil,
  employer_home_page: nil,
  opportunities: nil,
  from_date: nil,
  to_date: nil,
  external_logo_url: nil,
  application_url: nil,
  # relations
  location: Metrojobb::Location.new(city: 'Stockholm'),
  contact: Metrojobb::Contact.new(name: 'buren'),
  employment_type: Metrojobb::EmploymentType.new(id: '1'),
  category: Metrojobb::Category.new(id: '1'),
  region: Metrojobb::Region.new(id: '1')
)

ad.to_xml # Returns the ad as an XML-string
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Data

:warning: Current data in `data/` folder downloaded 2017-09-19 14:41 UTC.

Categories, regions and employment types implemented on Metrojobb.se
- Regions:  http://www.metrojobb.se/data/regions.csv
- Categories:  http://www.metrojobb.se/data/categories.csv
- Employment types:  http://www.metrojobb.se/data/employmenttypes.csv

__Update data__

```bash
cd data/
wget http://www.metrojobb.se/data/regions.csv
wget http://www.metrojobb.se/data/categories.csv
wget http://www.metrojobb.se/data/employmenttypes.csv
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/metrojobb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).