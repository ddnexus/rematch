# CHANGELOG

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

###  Changes

- added support for message argument and mixed arguments
- better tests examples and documentation

### Commits

- [87aed49](http://github.com/ddnexus/rematch/commit/87aed49): added support for message argument and mixed arguments
- [fcc976d](http://github.com/ddnexus/rematch/commit/fcc976d): README update
- [1bcb7fd](http://github.com/ddnexus/rematch/commit/1bcb7fd): better tests
- [75be17f](http://github.com/ddnexus/rematch/commit/75be17f): syntax fix in example
- [b16257a](http://github.com/ddnexus/rematch/commit/b16257a): better examples

## Version 1.2.0

###  Changes

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
- [a325562](http://github.com/ddnexus/rematch/commit/a325562): simplified naming of option: --rematch-refresh-only to --rematch-rebuild; updated README and tests
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
