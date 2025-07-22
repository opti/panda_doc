# Change Log

All notable changes to this project will be documented in this file.

## [Unreleased]
## [0.13.1][]

Fixes:

- Fixes #62 - make Document Sections attribute optional (@lannon)

## [0.13.0][]

New:

- Add Document Sections list and delete actions (by @lannon)


## [0.12.0][] (2025-06-20)

New:

- Add Document Sections support (by @andrewvy)

## [0.11.0][] (2025-04-19)

New:

- Drop ruby 2.7 & 3.0

## [0.10.0][] (2025-02-21)

New:

- Add `Document.editing_session` to [Create Document Editing Session](https://developers.pandadoc.com/reference/create-document-editing-session) (by @jonmchan)
  ```ruby
  session = PandaDoc::Document.editing_session("uuid", email: "john.doe@pandadoc.com", lifetime: 3600)
  session.key
  => "985b695b56eaaa571e9bb8e522afd5bd335c32d7"
  ```

Enhancements:

- Use Zeitwerk to load gem files.

## [0.9.0][] (2024-07-12)

New:

- Add `Document.list` for [List Documents](https://developers.pandadoc.com/reference/list-documents) endpoint.
  ```ruby
  list = PandaDoc::Document.list
  list.documents.first.name
  => "Sample Name"
  ```

## [0.8.0][] (2024-07-12)

New:

- Optional `metadata` field which can be used to store arbitrary data (by @andrewvy)
- `Document.move_to_draft` -> POST /documents/{id}/draft/ (by @andrewvy)
- `Document.update` -> PATCH /documents/{id}/ (by @andrewvy)

## [0.7.0][] (2023-06-07)

New:

- Drop ruby 2.6
- Update to Faraday 2

## [0.6.0][] (2022-05-04)

New:

- Add `roles`, `shared_link` and `contact_id` to the recipient in the document details response:
  ```ruby
    document = PandaDoc::Document.details("uuid")
    document.recipients.first.roles
    => ["Signer", "Reviewer"]

    document.recipients.first.shared_link
    => "https://app.pandadoc.com/document/b7f11ea3c09d1c11208cc122457d4f3a2829d364"

    document.recipients.first.contact_id
    => "7kqXgjFejB2toXxjcC5jfZ"
  ```

Fixes:

- Fixes #11 - make `FailureResult#response` public
- Fixes #8 - make `Recipient` attributes optional

## [0.5.3][] (2021-11-03)

Fixes:

- Fixes #5 - make `placeholder` attribute optional (@acuster77)

## [0.5.2][] (2021-03-08)

Fixes:

- Fixes #3 - `Dry::Struct::Error` when token.value is not provided.

## [0.5.1][] (2021-01-08)

New:

- Add `fields` to the document details response:
  ```ruby
    document = PandaDoc::Document.details("uuid")
    document.fields.first.name
    => "Field Name"

    docuemnt.fields.first.value
    => "Field Value"
  ```

## [0.5.0][] (2021-01-06)

New:

- Replace virtus with dry-struct.
- Drop support for ruby < 2.5.
- Add support for API-Key authentication.
  ```ruby
    PandaDoc.configure do |config|
      config.api_key = "API Key"
    end
  ```

- Add `id`, `expiration_date` and `version` to the response Document Object.
- Add [Document details](https://developers.pandadoc.com/reference#document-details) endpoint
  ```ruby
    document = PandaDoc::Document.details("uuid")
    document.tokens.first.name
    => "Token.Name"

    docuemnt.tokens.first.value
    => "Token Value"
  ```

- Add ruby 3.0 to test coverage.

## [0.4.3][] (2019-03-06)

Fixes:

- Relax bundler dependency

## [0.4.2][] (2019-03-06)

Fixes:

- Relax faraday dependency

## [0.4.1][] (2018-04-24)

Fixes:

- Remove deprecated `codeclimate-test-reporter`. (by @nicolasleger)
- Add ruby 2.4, 2.5 to test coverage. (by @nicolasleger)
- Update README with logger examples. (by @nicolasleger)

## [0.4.0][] (2016-05-19)

New:

- Add ability to create a document from attached pdf file.

  ```ruby
    file = UploadIO.new("/path/to/file.pdf", "application/pdf")

    PandaDoc::Document.create(
      file: file,
      name: "Sample",
      ...
    )
  ```

## [0.3.2][] (2016-04-15)

New:

- Add Document.find("uuid") shortcut to retreive document info.

  ```ruby
    document = PandaDoc::Document.find("uuid")
    document.status
    => "uploaded"

    docuemnt.name
    => "Document Name"
  ```

## [0.3.1][] (2016-03-04)

New:

- Add Document.download("uuid") shortcut.

  ```ruby
    response = PandaDoc::Document.download("uuid")
    file = File.open("document.pdf", "w") do |f|
      response.body
    end
  ```

## [0.3.0][] (2016-02-20)

### API change:

- Raise error on failed response.

  ```ruby
  begin
    PandaDoc::Document.create(name: "Sample")
  rescue PandaDoc::FailureResult => e
    puts e.detail
    puts e.response
  end
  ```

## [0.2.0][] (2016-02-18)

New:

- Add status coercion. It is now converted from `document.uploaded` to `uploaded`.

## [0.1.0][] (2016-02-17)

New:

- Mimic the original error structure. Error object on failure result will have
  two methods: `type` and `detail`, where is `detail` might be String or Hash

  ```ruby
    response.error.detail => "Not Found"
    response.error.detail => {"fields"=>["Field 'foo' does not exist."]}
  ```

## [0.0.2][] (2016-02-13)

New:

- Introduce `logger` configuration's option to debug requests/responses.

  ```ruby
  require 'logger'
  PandaDoc.configure do |config|
    config.logger = Logger.new(STDOUT)
  end
  ```

Fixes:

- Add support for simple error structure.

## 0.0.1 (2016-02-03)

- Initial release

[Unreleased]: https://github.com/opti/panda_doc/compare/v0.10.0...HEAD
[0.10.0]: https://github.com/opti/panda_doc/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/opti/panda_doc/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/opti/panda_doc/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/opti/panda_doc/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/opti/panda_doc/compare/v0.5.3...v0.6.0
[0.5.3]: https://github.com/opti/panda_doc/compare/v0.5.2...v0.5.3
[0.5.2]: https://github.com/opti/panda_doc/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/opti/panda_doc/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/opti/panda_doc/compare/v0.4.3...v0.5.0
[0.4.3]: https://github.com/opti/panda_doc/compare/v0.4.2...v0.4.3
[0.4.2]: https://github.com/opti/panda_doc/compare/v0.4.1...v0.4.2
[0.4.1]: https://github.com/opti/panda_doc/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/opti/panda_doc/compare/v0.3.2...v0.4.0
[0.3.2]: https://github.com/opti/panda_doc/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/opti/panda_doc/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/opti/panda_doc/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/opti/panda_doc/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/opti/panda_doc/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/opti/panda_doc/compare/v0.0.1...v0.0.2
