# PandaDoc

PandaDoc gem is a simple wrapper for PandaDoc.com API. Please check the official
API [documenation](https://developers.pandadoc.com) for more details.

[![Build Status](https://travis-ci.org/opti/panda_doc.svg?branch=master)](http://travis-ci.org/opti/panda_doc)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'panda_doc'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install panda_doc

## Configuration

Please refer to the [Authentication](https://developers.pandadoc.com/#authentication)
documentation to get the idea how to get an access token.

```ruby
PandaDoc.configure do |config|
  config.access_token = "an access token"
end
```

## Usage

Every response wrapped into a ruby object with values coerced in corresponding types.

#### Creating a document

```ruby
PandaDoc::Document.create(
  name: "Sample Document",
  url: "url_to_a_document",
  recipients: [
    {
      email: "john.appleseed@yourdomain.com",
      first_name: "John",
      last_name: "Appleseed",
      role: "Signer",
      default: false
    }
  ],
  fields: {
    field_id: {
      title: "Field 1"
    }
  }
)

document.uuid # => "oovHPtkwDqEAvaKmdud"
document.name # => "Sample Document"
document.status # => "document.uploaded"
document.created_at # => #<DateTime: 2016-02-03T14:56:21-08:00>
document.updated_at # => #<DateTime: 2016-02-03T14:56:21-08:00>
```

#### Creating a document from a template

```ruby
document = PandaDoc::Document.create(
  name: "Sample Document",
  template_uuid: "uuid_of_the_template",
  recipients: [
    {
      email: "john.appleseed@yourdomain.com",
      first_name: "John",
      last_name: "Appleseed",
      role: "Signer",
      default: false
    }
  ],
  fields: {
    field_id: {
      value: "Field 1"
    }
  }
)
```


#### Sending a document

```ruby
PandaDoc::Document.send("UUID", message: "A message to include into the email")
```

#### Ccreating a View Session

```ruby
session = PandaDoc::Document.session("UUID",
  recipient: "john.applessed@yourdoamin.com",
  lifetime: 300
)

session.id # => "adssdAvyDXBS"
session.expires_at # => #<DateTime: 2016-02-03T14:56:21-08:00>
```

#### Error handling

If an error occurs during an API request it will be wrapped into a plain ruby
object as well.

```ruby
response = PandaDoc::Document.create(name: "Sample Document")

if response.success?
  uuid = response.uuid
else
  puts response.error.message
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/opti/panda_doc.

1. Fork it ( https://github.com/opti/panda_doc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
