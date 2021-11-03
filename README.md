# PandaDoc

PandaDoc gem is a simple wrapper for PandaDoc.com API. Please check the official
API [documenation](https://developers.pandadoc.com) for more details.

[![Build Status](https://github.com/opti/panda_doc/actions/workflows/ci.yml/badge.svg)](https://github.com/opti/panda_doc/actions/workflows/ci.yml)
[![Code Climate](https://codeclimate.com/github/opti/panda_doc/badges/gpa.svg)](https://codeclimate.com/github/opti/panda_doc)
[![Test Coverage](https://codeclimate.com/github/opti/panda_doc/badges/coverage.svg)](https://codeclimate.com/github/opti/panda_doc/coverage)

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

Both [API-Key](https://developers.pandadoc.com/reference#api-key-authentication-process) and [oAuth2.0 access token](https://developers.pandadoc.com/reference#authentication-process) authentications are supported.

```ruby
PandaDoc.configure do |config|
  config.api_key = "api key"
end
```

```ruby
PandaDoc.configure do |config|
  config.access_token = "an access token"
end
```

## Usage

Every response wrapped into a ruby object with values coerced in corresponding types.

#### Creating a document

```ruby
document = PandaDoc::Document.create(
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
document.status # => "uploaded"
document.created_at # => #<DateTime: 2016-02-03T14:56:21-08:00>
document.updated_at # => #<DateTime: 2016-02-03T14:56:21-08:00>
```

#### Creating a document from attached file ([API](https://developers.pandadoc.com/reference#create-document-from-pdf))

```ruby
file = UploadIO.new("/path/to/file.pdf", "application/pdf")

document = PandaDoc::Document.create(
  name: "Sample Document",
  file: file,
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
```

#### Creating a document from a template ([API](https://developers.pandadoc.com/reference#create-document-from-pandadoc-template))

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
  tokens: [
    { name: "Token.Name", value: "Token Value" },
    { name: "Token.AnotherName", value: "2021" }
  ],
  fields: {
    field_id: {
      value: "Field 1"
    }
  }
)
```

#### Getting a document status ([API](https://developers.pandadoc.com/reference#document-status))

```ruby
document = PandaDoc::Document.find("UUID")

document.status       # => "draft"
document.updated_at   # => <DateTime: 2016-02-03T17:41:00-08:00>
```

#### Getting a document details ([API](https://developers.pandadoc.com/reference#document-details))

```ruby
document = PandaDoc::Document.details("UUID")

document.tokens
=> [#<PandaDoc::Objects::Token name="Token.Name" value="Token Value">,
    #<PandaDoc::Objects::Token name="token.another_name" value="2021">]

document.fields
=> [#<PandaDoc::Objects::Field uuid="...>,
    #<PandaDoc::Objects::Field uuid="...>]
```

#### Sending a document ([API](https://developers.pandadoc.com/reference#send-document))

```ruby
PandaDoc::Document.send("UUID", message: "A message to include into the email")
```

#### Creating a View Session

```ruby
session = PandaDoc::Document.session("UUID",
  recipient: "john.applessed@yourdoamin.com",
  lifetime: 300
)

session.id # => "adssdAvyDXBS"
session.expires_at # => #<DateTime: 2016-02-03T14:56:21-08:00>
```

#### Downloading a document ([API](https://developers.pandadoc.com/reference#download-document))

```ruby
response = PandaDoc::Document.download("uuid")
file = File.open("document.pdf", "w") do |f|
  response.body
end
```

#### Error handling

If an error occurs during an API request it will be wrapped into a plain ruby
object as well.

```ruby
begin
  PandaDoc::Document.create(name: "Sample Document")
rescue PandaDoc::FailureResult => e
  puts e.detail
  puts e.response
end
```

#### Debugging

You can configure a logger if you need to debug your requests/responses

```ruby
require 'logger'
PandaDoc.configure do |config|
  config.logger = Logger.new(STDOUT)
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
