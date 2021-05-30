# Rematch

[![Gem Version](https://img.shields.io/gem/v/rematch.svg?label=rematch&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/rematch)
[![Build Status](https://img.shields.io/github/workflow/status/ddnexus/rematch/Rematch%20CI/master)](https://github.com/ddnexus/rematch/actions?query=branch:master)
[![CodeCov](https://img.shields.io/codecov/c/github/ddnexus/rematch.svg?colorA=1f7a1f&colorB=2aa22a)](https://codecov.io/gh/ddnexus/rematch)
![Rubocop Status](https://img.shields.io/badge/rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)

## Overview

**Declutter your test files from large hardcoded data and update them automatically when your code changes.**

Instead of copying and pasting large outputs or big ruby structures into all the affected test files every time your code changes, you can do it the easy way, possibly saving many hours of boring maintenance work!

### Instead of maintaining this cluttered mess...

```ruby
it 'generates the pagination nav tag' do
  assert_equal "<nav id="test-nav-id" class="pagy-nav
  pagination" aria-label="pager"><span class="page prev"><a href="/foo?page=9"  link-extra
  rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> <span class="page"><a
  href="/foo?page=1"  link-extra >1</a></span> <span class="page gap">&hellip;</span>
  <span class="page"><a href="/foo?page=6"  link-extra >6</a></span> <span class="page"><a
  href="/foo?page=7"  link-extra >7</a></span> <span class="page"><a href="/foo?page=8"  link-extra
  >8</a></span> <span class="page"><a href="/foo?page=9"  link-extra rel="prev" >9</a></span>
  <span class="page active">10</span> <span class="page"><a href="/foo?page=11"  link-extra
  rel="next" >11</a></span> <span class="page"><a href="/foo?page=12"  link-extra
  >12</a></span> <span class="page"><a href="/foo?page=13"  link-extra >13</a></span>
  <span class="page"><a href="/foo?page=14"  link-extra >14</a></span> <span class="page
  gap">&hellip;</span> <span class="page"><a href="/foo?page=50"  link-extra >50</a></span>
  <span class="page next"><a href="/foo?page=11"  link-extra rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span></nav>" , 
  view.pagy_nav(pagy)
end

it 'generates the metadata hash' do
  assert_equal( 
    {
    :scaffold_url=>"http://www.example.com/subdir?page=__pagy_page__",
    :first_url=>"http://www.example.com/subdir?page=1",
    :prev_url=>"http://www.example.com/subdir?page=",
    :page_url=>"http://www.example.com/subdir?page=1",
    :next_url=>"http://www.example.com/subdir?page=2",
    :last_url=>"http://www.example.com/subdir?page=50",
    :count=>1000,
    :page=>1,
    :items=>20,
    :vars=>
     {:page=>1,
      :items=>20,
      :outset=>0,
      :size=>[1, 4, 4, 1],
      :page_param=>:page,
      :params=>{},
      :fragment=>"",
      :link_extra=>"",
      :i18n_key=>"pagy.item_name",
      :cycle=>false,
      :url=>"http://www.example.com/subdir",
      :headers=>
       {:page=>"Current-Page",
        :items=>"Page-Items",
        :count=>"Total-Count",
        :pages=>"Total-Pages"},
      :metadata=>
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
      :count=>1000},
    :pages=>50,
    :last=>50,
    :from=>1,
    :to=>20,
    :prev=>nil,
    :next=>2,
    :series=>["1", 2, 3, 4, 5, :gap, 50]
    }, 
    controller.pagy_metadata)
end
```

### Do it the easy way!

```ruby
it 'generates the pagination nav tag' do
  assert_rematch view.pagy_nav(pagy)
end
it 'generates the metadata hash' do
  assert_rematch controller.pagy_metadata
end
```

### How does it work?

The first time a new rematch test is run, its returned value is recorded in a `*.rematch` `YAML::Store` file (placed next to the test file). The next times the same test will run, its fresh returned value will be rematched against the recorded value, passing or failing the test as usual.

### How to update the stored values

When your code change you need to update the stored values with the new values from your current code. With `rematch` you don't need to edit the test files, you just delete the store files and re-run the tests, which will recreate the new updated stores.

You have a couple of options to do that:

- You can manually delete the specific store files (e.g. `frontend_test.rb.rematch`) and re-run the test(s).
- Or you can run the test(s) with the `--rematch-rebuild` option. For example:

    ```sh
    rake test TESTOPTS=--rematch-rebuild                # update all
    ruby -Ilib:test test/my_test.rb --rematch-rebuild   # update just one
    ```

    :warning: **WARNING**: Don't forget the  `--rematch-rebuild` option in some script that runs for actual testing or it will never fail!

### Assertions and Expectations

Rematch adds `assert_rematch` and `must_rematch` to `minitest`. By default, they use `assert_equal` behind the scenes after storing/retrieving the value to compare.

However you can use any other _equality assertion_ that better suits your needs. Here is an example with `assert_equal_unordered` (provided by `minitest-unordered` plugin):

```ruby
# instead of
assert_equal_unordered [:big, :expected, :enumerable, :collection, ...], my_enum_collection

# you can rematch it like: 
assert_rematch my_enum_collection, :assert_equal_unordered
# or
_(my_enum_collection).must_rematch :assert_equal_unordered
```

**Notice**: The symbol passed must identify an **equality assertion** method, i.e. the method must use a form of comparison of the whole stored value, and must be an assertion method like `:assert_something` and not an expectation method like `:must_something`.

Like any other minitest assertion/expectation, the rematch methods accept also an optional message argument (String or Proc) that gets forwarded to the used equality assertion method. Notice that the order of the assertion and message arguments is conveniently flexible. The following are all the possible ways you can use the rematch methods:

```ruby
assert_rematch my_value
assert_rematch my_value, :assert_something
assert_rematch my_value, 'my message' 
assert_rematch my_value, :assert_something, 'my message'
assert_rematch my_value, 'my message', :assert_something

_(my_value).must_rematch
_(my_value).must_rematch :assert_something
_(my_value).must_rematch 'my message'
_(my_value).must_rematch :assert_something, 'my message'
_(my_value).must_rematch 'my message', :assert_something
```

### Suggestions

#### Check the stores

Rematch stores the expected value for you: whatever is returned by your test expression is what will get stored and compared the next times. That is handy when you know that your code is working properly. If you are not so sure, you should check the stored values by taking a look at the `*.rematch` store files, which are very readable `YAML` files.

#### Dos and don'ts

- Use `rematch` with large output or structures that are mostly generated outside your test code. Rematch can declutter your tests and [update the stored values](#update-the-stored-values) in seconds. For example:

    ```ruby
    # cluttered and hard to update
    assert_equal '...big output spanning multiple lines ...', big_helper(a: 'a')
    assert_equal({ big: { deeply: 'nested', complicated: 'structure'}, ...}, big_struct(b: 'b'))
    
    # this is better
    assert_rematch big_helper(a: 'a')
    assert_rematch big_struct(b: 'b')
    # or this
    _(big_helper(a: 'a')).must_rematch
    _(big_struct(b: 'b')).must_rematch 
    ```

- Don't use `rematch` for short specific outputs mostly dependent on the test code. For example:

    ```ruby
    # less readable and harder to update 
    assert_rematch square_root(100) 
    _(square_root(10_000)).must_rematch
    
    # this is better
    assert_equal 10, square_root(100) 
    _(square_root(10_000)).must_equal 100
    ```

#### Test the whole instead of parts

- Without `rematch` if you want to avoid adding clutter and future maintenance, you have to pinpoint the parts worth testing out of a big output or structure. That requires deciding which part is important and which is not, and writing the code to extract the parts and testing each one of them.
- With `rematch` you can just relax and test the whole output/structure with a single deadly-simple line: way simpler, more effective, without clutter and maintenance free!

## Installation

Rematch works as a `minitest` plugin, so just add it to your `Gemfile` (usually in the `:test` group) or require it if you don't use `bundler`, and minitest will find and load it.

After that you can just use its assertions/expectations in your tests.

## Caveats

- You can use `rematch` with any value, even your own complex objects and even without serialization, however since they get compared by minitest, they must implement a `==` method like any other native ruby object.
- Editing an existing test file containing rematch tests may cause the failure of some test that has exchanged its position with another in the block/method. In that case just [update the stored values](#update-the-stored-values).

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

