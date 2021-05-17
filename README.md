# Rematch

[![Gem Version](https://img.shields.io/gem/v/rematch.svg?label=rematch&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/rematch)
[![Build Status](https://img.shields.io/github/workflow/status/ddnexus/rematch/Rematch%20CI/master)](https://github.com/ddnexus/rematch/actions?query=branch:master)
[![CodeCov](https://img.shields.io/codecov/c/github/ddnexus/rematch.svg?colorA=1f7a1f&colorB=2aa22a)](https://codecov.io/gh/ddnexus/rematch)
![Rubocop Status](https://img.shields.io/badge/rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)

## Overview

Declutter your test files from hardcoded expected data and when your code changes, update them in a few seconds instead of hours!

Instead of copying and pasting large outputs or big ruby structures into all the affected test files every time your code change, you just reset `rematch` and run the tests again. The new values from your code will get stored and used as expected values for the next text runs.

## Usage

Currently rematch works as a `minitest` plugin. Just add it to your `Gemfile` (usually in the `:test` group) or, if you don't use it, just `require 'rematch'` in your code.

Then, instead of this kind of mess:

```ruby
it 'generates this big output' do
_(MyHelper.my_output).must_equal "<... 300 lines of HTML ...
............................................................
............................................................
............................................................"
end
it 'generate this big structure' do
_(MyAPI.my_output).must_equal [
  { a: { big: { structure: 'with many',
                different: ['values', 'and', 'stuff'] 
              }
       },
    and: 'hundreds',
    of: 'levels',
  },
  ..............
  ..............
  ..............
  ..............       
]
end
```

...you can just write:

```ruby
it 'generates this big output' do
_(MyHelper.my_output).must_rematch
end
it 'generate this big structure' do
_(MyAPI.my_output).must_rematch
end
```

Rematch uses `YAML::Store` to store and rematch the result of your tests.

The first time a new rematch test is run it records its returned value. The next times the same test is run, it will rematch its fresh returned value against the recorded value. Obviously, the test will fail if the values don't match.

### Update

Rematch creates a `*.rematch` store file for each test file that uses it. When you need to update the store to the new values you have a few choices:

- Just delete the specific store file that you want to update (e.g. `frontend_test.rb.rematch`) and rerun the test
- Or run the [rematch:reset task](#rematchreset) to delete all the store files of your test suite and rerun all the tests
- In theory you could also search the entry in the store file and remove/edit it, but that's not practical nor recommended, but it could be OK if you want to force the failure of a test.

### Assertions/expectations

Rematch adds `assert_rematch` and `must_rematch` to the `minitest` assertions and expectations.

That uses `assert_equal` and `must_equal` behind the scene after storing/retrieving the value to match.

### rematch:reset

Run `rake rematch:reset` to delete all the `*.rematch` store files below the current dir.

Run `rake rematch:reset tree=path/to/test` to delete all the `*.rematch` store files below the `path/to/test` dir.

The store files will get recreated the next time you will run the tests.

## Caveats

- You can use rematch with pretty much everything, even your own complex objects, however, since rematch works by comparing values, the stored values have to implement a `==` method (like any other native ruby object does)
- If you edit the test file, (e.g. inserting rematch tests in the file or changing method names or description) the test location/id will change, so rematch will save a new entry, leaving the old entry orphaned. That will not affect testing, however if you want to keep it tidy, you can [update](#update) the affected store files.

## Repository Info

### Ruby version

This repo is tested from `2.5+` for practical CI reasons, but it should work also from `2.1+`.

### Versioning

Rematch follows the [Semantic Versioning 2.0.0](https://semver.org/). Please, check the [Changelog](https://github.com/ddnexus/rematch/blob/master/CHANGELOG.md) for breaking changes introduced by mayor versions.

### Contributions

Pull Requests are welcome!

If you Create A Pull Request, please ensure that the "All checks have passed" indicator gets green light on the Pull Request page. That means that the tests passed and Codecov and Rubocop are happy.

### Branches

The `master` branch is the latest rubygem-published release. It also contains docs and comment changes that don't affect the published code. It is never force-pushed.

The `dev` branch is the development branch with the new code that will be merged in the next release. It could be force-pushed.

Expect any other branch to be experimental, force-pushed, rebased and/or deleted even without merging.

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

