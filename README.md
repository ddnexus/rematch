# Rematch

[![Gem Version](https://img.shields.io/gem/v/rematch.svg?label=rematch&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/rematch)
[![Build Status](https://img.shields.io/github/actions/workflow/status/ddnexus/rematch/rematch-ci.yml?branch=master)](https://github.com/ddnexus/rematch/actions/workflows/rematch-ci.yml?query=branch%3Amaster)</span> <span>
![Coverage](https://img.shields.io/badge/coverage-100%25-coverage.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
![Rubocop Status](https://img.shields.io/badge/rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)

## Overview

**Declutter your test files from large hardcoded data and update them automatically when your code changes.**

Instead of copying and pasting large outputs or big ruby structures into all the affected test files every time your code changes,
you can do it the easy way, possibly saving many hours of boring maintenance work!

### Instead of maintaining this cluttered mess...

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
  assert_rematch :nav, view.pagy_nav(pagy)
end
it 'generates the metadata hash' do
  assert_rematch :meta, controller.pagy_metadata
end
# :nav and :meta are arbitrary keys for storing the test case 
# they must be unique inside the test block
```

### How does it work?

The first time a new rematch test is run, its returned value is recorded in a `*.rematch` `YAML::Store` file (placed next to the
test file). The next times the same test will run, its fresh returned value will be rematched against the recorded value, passing
or failing the test as usual.

### How to update the stored values

With or without `rematch`, when your code change you need to update the stored values with the new values from your current code.
With `rematch` you don't need to edit the test files, instead you have a few options:

- Run the test(s) with the `--rematch-rebuild` option: it will rebuild the `.rematch` store files for all the tests that you run.
  For example:

    ```sh
    rake test TESTOPTS=--rematch-rebuild                # update all
    ruby -Ilib:test test/my_test.rb --rematch-rebuild   # update just one
    ```

  :warning: **WARNING**: Don't forget the  `--rematch-rebuild` option in some script that runs for actual testing or it will never
  fail!
- You can manually delete the specific store files (e.g. `frontend_test.rb.rematch`) and re-run the test(s).
- You can temporarily replace the `assert_rematch`/`must_rematch` calls that you want to update
  with `store_assert_rematch`/`store_must_rematch` respectively. That will store the new value passed to the assertion/expectation
  and will fail the test (in order to avoid to store every time any value). Just restore the
  original `assert_rematch`/`must_rematch` call and the test will pass.

### Assertions and Expectations

Rematch adds `assert_rematch` and `must_rematch` to `minitest`. By default, they use `assert_equal` or `assert_nil` (for `nil`
values) behind the scenes after storing/retrieving the value to compare.

However you can use any other _equality assertion_ that better suits your needs. Here is an example
with `assert_equal_unordered` (provided by `minitest-unordered` plugin):

```ruby
# instead of
assert_equal_unordered [:big, :expected, :enumerable, :collection, ...], my_enum_collection

# you can rematch it like: 
assert_rematch :my_key, my_enum_collection, :assert_equal_unordered
# or
_(my_enum_collection).must_rematch :my_key, :assert_equal_unordered
```

**Notice**: The symbol passed must identify an **equality assertion** method, i.e. the method must use a form of comparison of the
whole stored value, and must be an assertion method like `:assert_something` and not an expectation method like `:must_something`.

Like any other minitest assertion/expectation, the rematch methods accept also an optional message argument (String or Proc) that
gets forwarded to the used equality assertion method. Notice that the order of the assertion and message arguments is conveniently
flexible. The following are all the possible ways you can use the rematch methods:

```ruby
assert_rematch :c1, my_value
assert_rematch :c1, my_value, :assert_something
assert_rematch :c1, my_value, 'my message'
assert_rematch :c1, my_value, :assert_something, 'my message'
assert_rematch :c1, my_value, 'my message', :assert_something

_(my_value).must_rematch :c1
_(my_value).must_rematch :c1, :assert_something
_(my_value).must_rematch :c1, 'my message'
_(my_value).must_rematch :c1, :assert_something, 'my message'
_(my_value).must_rematch :c1, 'my message', :assert_something
```

### Suggestions

#### Test case keys

Rematch assertions/expectations are typical Minitest assertions/expectations, with the extra feature to store and retrieve
automatically the expected value from a key-value store.

Before `rematch v2.0` the keys were based on the sequential position of the test cases inside the test block, but that was very
fragile and need to rebuild the store every time you move around/add/remove cases.

Since `rematch v2.0` you must pass an arbitrary key as the first argument to any rematch assertion/expectation.

The key must be unique inside the test block because it's used to identify each specific test case. You can use any value that
could be used as a Hash key (e.g. symbol, string, integer, and almost everything), however it's much more practical to use
descriptive symbols for each test case or a no-brainer series of symbols (e.g. :c1, :c2, c3, ...). That will be also very useful
to match the case against the store file, when you want to check the stored values.

#### Check the stores

Rematch stores the expected value for you: whatever is returned by your test expression is what will get stored and compared the
next times. That is handy when you know that your code is working properly. If you are not so sure, you should check the stored
values by taking a look at the `*.rematch` store files, which are very readable `YAML` files.

#### Update flow

When you first run your new tests, `rematch` stores whatever value they return under the storage case key that is derived from the
test description.

If you change your code later, you should ensure that the old tests pass before changing the test files. If there is some expected
failure, you should reconcile them, usually by temporarily replacing the `assert_rematch`/`must_rematch` calls that you want to
update with `store_assert_rematch`/`store_must_rematch` respectively.

From time to time, you may want to rebuild a totally passing test suite just to cleanup orphan keys and reorganizing the tests in
a better order. IMPORTANT: DO NOT REBUILD unless everything passes, or you will have stored the wrong actual values!

#### Dos and don'ts

- Use `rematch` with large output or structures that are mostly generated outside your test code. Rematch can declutter your tests
  and [update the stored values](#how-to-update-the-stored-values) in seconds. For example:

    ```ruby
    # cluttered and hard to update
    assert_equal '...big output spanning multiple lines ...', big_helper(a: 'a')
    assert_equal({ big: { deeply: 'nested', complicated: 'structure'}, ...}, big_struct(b: 'b'))
    
    # this is better
    assert_rematch :helper, big_helper(a: 'a')
    assert_rematch :struct, struct(b: 'b')
    # or this
    _(big_helper(a: 'a')).must_rematch :helper
    _(big_struct(b: 'b')).must_rematch :struct
    ```

- Don't use `rematch` for short specific outputs mostly dependent on the test code. For example:

    ```ruby
    # less readable and harder to update 
    assert_rematch :root, square_root(100) 
    _(square_root(10_000)).must_rematch :root
    
    # this is better
    assert_equal 10, square_root(100) 
    _(square_root(10_000)).must_equal 100
    ```

#### Test the whole instead of parts

- Without `rematch` if you want to avoid adding clutter and future maintenance, you have to pinpoint the parts worth testing out
  of a big output or structure. That requires deciding which part is important and which is not, and writing the code to extract
  the parts and testing each one of them.
- With `rematch` you can just relax and test the whole output/structure with a single deadly-simple line: way simpler, more
  effective, without clutter and maintenance free!

## Installation

Rematch works as a `minitest` plugin, so just add it to your `Gemfile` (usually in the `:test` group) or require it if you don't
use `bundler`, and minitest will find and load it.

After that you can just use its assertions/expectations in your tests.

## Caveats

- You can use `rematch` with any value, even your own complex objects and even without serialization, however since they get
  compared by minitest, they must implement a `==` method like any other native ruby object.
- If you have to run the same tests on different ruby versions, the `.rematch` file may not be read the same way in different
  versions due to `Psych` changes between versions. That should only happen in complex objects that use `ivars`. A work-around the
  issue is storing the raw data underlying the object. For example a `.to_hash` or `.attributes` would store only plain hashes
  instead of the whole instance with its variables, and that is good enough for testing.

## Repository Info

### Ruby version

This repo is tested from `2.5+` for practical CI reasons, but it should work also from `2.1+`.

### Versioning

Rematch follows the [Semantic Versioning 2.0.0](https://semver.org/). Please, check
the [Changelog](https://github.com/ddnexus/rematch/blob/master/CHANGELOG.md) for breaking changes introduced by mayor versions.

### Contributions

Pull Requests are welcome!

If you Create A Pull Request, please ensure that the "All checks have passed" indicator gets green light on the Pull Request page.
That means that the tests passed and Codecov and Rubocop are happy.

### Branches

The `master` branch is the latest rubygem-published release. It also contains docs and comment changes that don't affect the
published code. It is never force-pushed.

The `dev` branch is the development branch with the new code that will be merged in the next release. It could be force-pushed.

Expect any other branch to be experimental, force-pushed, rebased and/or deleted even without merging.

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
