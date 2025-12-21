# Rematch

[![Gem Version](https://img.shields.io/gem/v/rematch.svg?label=rematch&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/rematch)
[![Build Status](https://img.shields.io/github/actions/workflow/status/ddnexus/rematch/rematch-ci.yml?branch=master)](https://github.com/ddnexus/rematch/actions/workflows/rematch-ci.yml?query=branch%3Amaster)</span> <span>
![Coverage](https://img.shields.io/badge/coverage-100%25-coverage.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
![Rubocop Status](https://img.shields.io/badge/rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)

## Overview

**Declutter your test files and automatically update expected values when your code changes.**

Don't copy-paste large outputs or structures into your tests. Rematch saves you hours of tedious maintenance by storing expected values in separate files and verifying them for you.

### Instead of this mess...

```ruby
it 'generates the pagination nav tag' do
  assert_equal "<nav id=" test - nav - id " class=" pagy - nav
  pagination " aria-label=" pager "><span class=" page prev "><a href=" / foo? page = 9 "  link-extra
  rel=" prev " aria-label=" previous ">&lsaquo;&nbsp;Prev</a></span> <span class=" page "><a
  href=" / foo? page = 1 "  link-extra >1</a></span> <span class=" page gap ">&hellip;</span>
  <span class=" page "><a href=" / foo? page = 6 "  link-extra >6</a></span> <span class=" page "><a
  href=" / foo? page = 7 "  link-extra >7</a></span> <span class=" page "><a href=" / foo? page = 8 "  link-extra
  >8</a></span> <span class=" page "><a href=" / foo? page = 9 "  link-extra rel=" prev " >9</a></span>
  <span class=" page active ">10</span> <span class=" page "><a href=" / foo? page = 11 "  link-extra
  rel=" next " >11</a></span> <span class=" page "><a href=" / foo? page = 12 "  link-extra
  >12</a></span> <span class=" page "><a href=" / foo? page = 13 "  link-extra >13</a></span>
  <span class=" page "><a href=" / foo? page = 14 "  link-extra >14</a></span> <span class=" page
  gap ">&hellip;</span> <span class=" page "><a href=" / foo? page = 50 "  link-extra >50</a></span>
  <span class=" page next "><a href=" / foo? page = 11 "  link-extra rel=" next " aria-label=" next ">Next&nbsp;&rsaquo;</a></span></nav>",
  view.pagy_nav(pagy)
end

it 'generates the metadata hash' do
  assert_equal(
  {
  :scaffold_url => "http://www.example.com/subdir?page=__pagy_page__",
  :first_url    => "http://www.example.com/subdir?page=1",
  :prev_url     => "http://www.example.com/subdir?page=",
  :page_url     => "http://www.example.com/subdir?page=1",
  :next_url     => "http://www.example.com/subdir?page=2",
  :last_url     => "http://www.example.com/subdir?page=50",
  :count        => 1000,
  :page         => 1,
  :items        => 20,
  :vars         =>
  { :page       => 1,
    :items      => 20,
    :outset     => 0,
    :size       => [1, 4, 4, 1],
    :page_param => :page,
    :params     => {},
    :fragment   => "",
    :link_extra => "",
    :i18n_key   => "pagy.item_name",
    :cycle      => false,
    :url        => "http://www.example.com/subdir",
    :headers    =>
    { :page  => "Current-Page",
      :items => "Page-Items",
      :count => "Total-Count",
      :pages => "Total-Pages" },
    :metadata   =>
    [:scaffold_url,
     :first_url,
     :prev_url,
     :page_url,
     :next_url,
     :last_url,
     :count,
     :page,
     :items,
     :vars,
     :pages,
     :last,
     :from,
     :to,
     :prev,
     :next,
     :series],
    :count      => 1000 },
  :pages        => 50,
  :last         => 50,
  :from         => 1,
  :to           => 20,
  :prev         => nil,
  :next         => 2,
  :series       => ["1", 2, 3, 4, 5, :gap, 50]
  },
  controller.pagy_metadata)
end
```

### Do it the easy way!

```ruby
it 'generates the pagination nav tag' do
  # Assertion
  assert_rematch view.pagy_nav(pagy)
  
  # Expectation (standard)
  _(view.pagy_nav(pagy)).must_rematch
  
  # Expectation (fluent / RSpec-style)
  value(view.pagy_nav(pagy)).must_rematch
  expect(view.pagy_nav(pagy)).to_rematch
end
```

## Installation

Add `rematch` to your `Gemfile` (usually in the `:test` group).
Minitest < 6.0 loads it automatically. For Minitest >= 6.0, add `Minitest.load :rematch` to your `test_helper.rb`.

## Usage

### How it works

The first time a test runs, Rematch records the returned value in a `*.yaml` file next to the test. The key is automatically generated from the line number and a test ID. Subsequent runs compare the fresh value against the recording, passing or failing as usual.

### Updating stored values

When your code changes, you can update the store without editing test files:

1.  **Rebuild all:** Run tests with the `--rematch-rebuild` option.
    ```sh
    rake test TESTOPTS=--rematch-rebuild
    ```
    :warning: **WARNING:** Only use this when you are sure the new output is correct.

2.  **Manual deletion:** Delete the specific `*.yaml` store file and re-run the test.

3.  **Selective update:** Temporarily replace the check with its `store_` counterpart:
  *   `assert_rematch` &rarr; `store_assert_rematch`
  *   `must_rematch` &rarr; `store_must_rematch`
  *   `to_rematch` &rarr; `store_to_rematch`

    This stores the new value and fails the test (to prevent committing the `store_` call). Revert to the original method to pass the test.

### Assertions and Expectations

Rematch wraps `assert_equal` (or `assert_nil`) by default. You can also specify a different equality assertion (e.g., `assert_equal_unordered`).

```ruby
# Standard usage
assert_rematch actual
_(actual).must_rematch

# With custom assertion
assert_rematch actual, :assert_equal_unordered
_(actual).must_rematch :assert_equal_unordered
expect(actual).to_rematch :assert_equal_unordered

# With message
assert_rematch actual, 'message'
_(actual).must_rematch 'message'
```

**Note:** The custom assertion must be a symbol (e.g., `:assert_something`). The order of arguments (assertion symbol vs message) is flexible.

### Parameterized Tests (Loops)

Since Rematch uses line numbers to generate keys, assertions inside loops or blocks need a unique identifier to avoid collisions. Use the id: option:

```ruby
[:alpha, :beta].each do |val|
assert_rematch val, id: val
_(val).must_rematch id: val
end
```

The stored key will include the `ID: L<num> [<id>] <SHA1>`.
## Suggestions

*   **Check the stores:** If you are unsure about the output, check the readable `*.yaml` files. Keys starting with `L<num>` make it easy to find the corresponding test case at the line indicated.
*   **Update flow:** Ensure tests pass before rebuilding. If there are expected failures, use the `store_*` methods to reconcile specific tests.
*   **Test the whole:** Don't pick apart complex structures. Test the whole output with a single line. Rematch handles the complexity for you.
*   **Dos and Don'ts:** Use Rematch for large, stable outputs (HTML, JSON, Hashes). Stick to standard assertions for simple values (integers, short strings).

## Caveats

*   **Equality:** Stored values are compared using standard Minitest assertions. Custom objects must implement `==`.
*   **Ruby Versions:** Complex objects with `ivars` might serialize differently across Ruby versions due to `Psych`. Store raw data (hashes/attributes) to avoid this.

## Repository Info

### Ruby version

Tested on `3.2+`, but compatible with `2.1+`.

### Versioning

Follows [Semantic Versioning 2.0.0](https://semver.org/). See the [Changelog](https://github.com/ddnexus/rematch/blob/master/CHANGELOG.md).

### Contributions

Pull Requests are welcome! Ensure tests, Codecov, and Rubocop pass.

### Branches

*   `master`: Latest published release. Never force-pushed.
*   `dev`: Development branch. May be force-pushed.

## License

[MIT License](https://opensource.org/licenses/MIT).
