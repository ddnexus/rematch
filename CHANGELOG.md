# CHANGELOG

## Version 5.0.0

- Update gems
- Deep refactoring:
  - Store files are always up-to-date reflecting the source
  - Human-readable keys, allowing the user to easily correlate stored values with test code by line number and custom labels
  - Rematch reads and (if needed) writes the store only once per file run
  - Better docs, better tests

## Version 4.1.0

- Added the id option for using rematch in loops

## Version 4.0.0

- Simplify usage and store readability:- Remove the mandatory unique key for test cases.
- Improve the store-file structure and readability by test line
- Implement tidy store automation:
  - remove orphan entries
  - keep the file ordered like the test file

## Version 3.2.2

- Avoid loading expectations unless the user require minitest/spec

## Version 3.2.1

- Update to minitest 6: 
  - update gems 
  - simplify test and coverage setup
- Rename Test RM config

## Version 3.2.0

- Add the Rematch::Store to override the YAML::Store load. Psych uses safe_load now (we use only trusted content)
- Remove gem and code relative to `rake-manifest`
- Add `pstore` and `logger` to the Gemfile (will not be core libs from ruby 3.5)
- Improve ci

## Version 3.1.0

- Add store_warning and Rematch.skip_warning; remove store method
- Remove useless test case
- Rename the DEFAULT constant to CONFIG

## Version 3.0.0

- Refactor keys and default extension
  - Changed default extension for rematch files to .yml
  - Rematch::EXT is now Rematch::DEFAULT[:ext], so it doesn't trigger the ruby warning when you change it
  - Rematch::DEFAULT[:ext] default value is `.yml` now
  - The test keys in the storage files have no "#", ":" and spaces... only "_", so they are easier to parse even with clumsy yaml
    parsers/highlighters (in case you want to inspect them, they will look right and easier to read)

## Version 2.1.0

- Nil values use assert_nil after deprecation of assert_equal nil

## Version 2.0.0

- Refactor key and storage system:
  - You must pass an explicit store key as the first argument for each rematch test
  - The tests will work even when moved around (providing the same key is used)
  - The .rematch store files are more readable for easily check and pair the stored values with the test expected values

- Updated github actions
- Updated gems, ruby prereq and rubocop to 3.1

## Version 1.4.2

- Update rematch.gemspec (#1)

## Version 1.4.1

- Normalized comments and naming
- Added bump.sh utility script
- Added more gemspec metadata entries

## Version 1.4.0

- Added store rematch for easy reconciling of changed values
- Better cops for rubocop
- Updated gemfiles and normalized comments
- Updated gemfiles and gemspec
- Fix for release-gem workflow
- Docs improvements
- Added RubyMine run configurations
- Added release-gem action
- Refactoring of coverage
- Updated rubocop cops
- Updated gemfiles
- maintenance update:- updated Gemfile
- added minitest-reportes
- better rubocop compliance
- fix for file missing coverage
- improved gitignore

## Version 1.3.1

### Changes

- fix for warning of uninitialized @rebuild variable

### Commits

- [404f4a9](http://github.com/ddnexus/rematch/commit/404f4a9): set explicit default value to @rebuild
- [7ea5991](http://github.com/ddnexus/rematch/commit/7ea5991): Small README adjustments
- [ef67f74](http://github.com/ddnexus/rematch/commit/ef67f74): fix for test depending on the previous
- [b730763](http://github.com/ddnexus/rematch/commit/b730763): Readme fixes and improvements

## Version 1.3.0

### Changes

- added support for message argument and mixed arguments
- better tests examples and documentation

### Commits

- [87aed49](http://github.com/ddnexus/rematch/commit/87aed49): added support for message argument and mixed arguments
- [fcc976d](http://github.com/ddnexus/rematch/commit/fcc976d): README update
- [1bcb7fd](http://github.com/ddnexus/rematch/commit/1bcb7fd): better tests
- [75be17f](http://github.com/ddnexus/rematch/commit/75be17f): syntax fix in example
- [b16257a](http://github.com/ddnexus/rematch/commit/b16257a): better examples

## Version 1.2.0

### Changes

- Refactoring of assertions (improvement and fixes)
- Strictened Rubocop

### Commits

- [bc799ba](http://github.com/ddnexus/rematch/commit/bc799ba): strictened rubocop
- [856d0da](http://github.com/ddnexus/rematch/commit/856d0da): refactoring of assertions:
  - avoid the initial nil in assertions
  - used dont_flip for expectation and flipped args in assertion
  - simplified equality/assert_method argument
  - added assertions in tests and README

## Version 1.1.0

### Changes

- Renamed --rematch-refresh-only to --rematch-rebuild
- Added equality argument
- Improved code, tests and documentation

### Commits

- [80fc503](http://github.com/ddnexus/rematch/commit/80fc503): added equality argument
- [a325562](http://github.com/ddnexus/rematch/commit/a325562): simplified naming of option: --rematch-refresh-only to
  --rematch-rebuild; updated README and tests
- [187e9ab](http://github.com/ddnexus/rematch/commit/187e9ab): improved README and gmspec description
- [ff273fc](http://github.com/ddnexus/rematch/commit/ff273fc): added gemspec to the Gemfile
- [01d3f38](http://github.com/ddnexus/rematch/commit/01d3f38): Minor README improvements

## Version 1.0

### Changes

- Compliance with the Semantic Versioning guideline
- Replaced the rematch:reset rake task with the --rematch-refresh-only option
- Completed testing
- Reduced ruby version requirement
- Completed documentation

### Commits

- [6c2968d](http://github.com/ddnexus/rematch/commit/6c2968d): General refactoring for version 1.0 \[...\]
- [2224433](http://github.com/ddnexus/rematch/commit/2224433): Doc improvements and fixes

## Version 0.0.1

### Changes

- Initial implementation

### Commits

- [9011e40](http://github.com/ddnexus/rematch/commit/9011e40): Initial commmit
