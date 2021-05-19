# Rematch

[![Gem Version](https://img.shields.io/gem/v/rematch.svg?label=rematch&colorA=99004d&colorB=cc0066)](https://rubygems.org/gems/rematch)
[![Build Status](https://img.shields.io/github/workflow/status/ddnexus/rematch/Rematch%20CI/master)](https://github.com/ddnexus/rematch/actions?query=branch:master)
[![CodeCov](https://img.shields.io/codecov/c/github/ddnexus/rematch.svg?colorA=1f7a1f&colorB=2aa22a)](https://codecov.io/gh/ddnexus/rematch)
![Rubocop Status](https://img.shields.io/badge/rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)

## Overview

Declutter your test files from large hardcoded data and update them automatically when your code changes.

Instead of copying and pasting large outputs or big ruby structures into all the affected test files every time your code change, you can do it the easy way, possibly saving many hours of boring maintenance work!

### Instead of maintaining this cluttered mess...

```ruby
it 'generates the pagination nav tag' do
  _(view.pagy_nav(pagy)).must_equal "<nav id="test-nav-id" class="pagy-nav
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
  <span class="page next"><a href="/foo?page=11"  link-extra rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span></nav>"
end

it 'generates the metadata hash' do
  _(controller.pagy_metadata).must_equal( 
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
    } 
  )
end
```

### Do it the easy way!

```ruby
it 'generates the pagination nav tag' do
  _(view.pagy_nav(pagy)).must_rematch
end
it 'generates the metadata hash' do
  _(controller.pagy_metadata).must_rematch
end
```

### How does it work?

The first time a new rematch test is run, its returned value is recorded in a `*.rematch` `YAML::Store` file. The next times the same test will run, its fresh returned value will be rematched against the recorded value, passing or failing the test exactly as it does with hardcoded expected values.

### Refresh the stored values

When your code change you can run the tests with the `--rematch-refresh-only` option in order to refresh the stored values with the new values from your current code. For example:

```sh
rake test TESTOPTS=--rematch-refresh-only
ruby -Ilib:test test/my_test.rb --rematch-refresh-only
```

:warning: **WARNING** :warning: As the name tries to suggest, the `--rematch-refresh-only` option runs the rematch tests as `refresh-only` and does not actually run any real comparison. You should re-run the tests without the option in order to verify that they actually pass.

Alternatively, you can just manually delete the specific store files that you want to refresh (e.g. `frontend_test.rb.rematch`) and rerun the tests.

### Assertions and Expectations

Rematch adds `assert_rematch` and `must_rematch` to `minitest`. That uses `assert_equal`/`must_equal` behind the scene after storing/retrieving the value to compare.

## Installation

Rematch works as a `minitest` plugin, so just add it to your `Gemfile` (usually in the `:test` group) or require it if you don't use `bundler`, and minitest will find and load it.

After that you can just use its assertions/expectations in your tests.

## Caveats

- You can use `rematch` with pretty much any value, even your own complex objects and even without serialization, however since they get compared by minitest, they must implement a `==` method like any other native ruby object.
- Editing an existing test file containing rematch tests may orphan some entry in the store file. That will not affect your test results, however you can [refresh the stored values](#refresh-the-stored-values) if you want to keep it tidy.

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

