# Change Log

All notable changes to this project will be documented in this file.

## [Unreleased]

New:

- Introduce `logger` configuration's option to debug requests/responses.

  ```ruby
  PandaDoc.configure do |config|
    config.logger = Logger.new(STDOUT)
  end
  ```

Fixes:

- Add support for simple error structure.

## 0.0.1 (2016-02-03)

- Initial release

[Unreleased]: https://github.com/opti/panda_doc/compare/v0.0.1...HEAD
