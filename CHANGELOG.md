# Change Log

All notable changes to this project will be documented in this file.

## [Unreleased]

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

[Unreleased]: https://github.com/opti/panda_doc/compare/v0.4.3...HEAD
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
