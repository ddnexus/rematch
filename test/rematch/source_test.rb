# frozen_string_literal: true

require_relative '../test_helper'
require 'rematch/source'

describe Rematch::Source do
  let(:code_fixture) do
    <<~RUBY
      class RootClass
        def test_method_a
          assert_rematch "value"
        end

        describe "Nested Describe" do
          it "has a spec assertion" do
            expect("val").to_rematch
          end
      #{'    '}
          it "has identical code" do
            expect("val").to_rematch
          end
        end
      end
    RUBY
  end

  let(:source) { Rematch::Source.new(code_fixture) }
  let(:result) { source.index }

  it 'finds assertions at expected lines' do
    # L3: assert_rematch
    # L8: expect().to_rematch
    # L12: expect().to_rematch
    _(result[3].size).must_equal 1
    _(result[8].size).must_equal 1
    _(result[12].size).must_equal 1
  end

  it 'generates SHAs based on Path + Content' do
    sha_3  = result[3].first
    sha_8  = result[8].first
    sha_12 = result[12].first

    _(sha_3).wont_be_nil
    _(sha_3).wont_equal sha_8
    _(sha_8).wont_equal sha_12
  end

  it 'generates identical SHAs for identical context and code' do
    dup_code = <<~RUBY
      class Dupe
        def test_dup
          assert_rematch "val"
          assert_rematch "val"
        end
      end
    RUBY

    dup_result = Rematch::Source.new(dup_code).index
    # L3 and L4
    _(dup_result[3].first).must_equal dup_result[4].first
  end

  it 'assigns one SHA per line even with multiple assertions' do
    # The Scan Everything strategy generates one ID per line based on content.
    # The Runtime handles the cycling.
    multi_code = <<~RUBY
      class Multi
        def test_multi
          assert_rematch("a"); assert_rematch("a")
        end
      end
    RUBY

    multi_result = Rematch::Source.new(multi_code).index
    # L3
    _(multi_result[3].size).must_equal 1
  end

  it 'ignores comments in assertion lines for SHA generation' do
    code_with_comment = <<~RUBY
      class Comment
        def test_comment
          assert_rematch "val" # comment
        end
      end
    RUBY

    code_without_comment = <<~RUBY
      class Comment
        def test_comment
          assert_rematch "val"
        end
      end
    RUBY

    res1 = Rematch::Source.new(code_with_comment).index[3].first
    res2 = Rematch::Source.new(code_without_comment).index[3].first

    _(res1).must_equal res2
  end

  it 'handles symbols and interpolation in context descriptions' do
    complex_code = <<~RUBY
      module Mod
        describe :symbol_context do
          it "interpolates \#{var}" do
            assert_rematch "ok"
          end
        end
      end
    RUBY

    res = Rematch::Source.new(complex_code).index
    _(res[4]).wont_be_nil
    _(res[4].first).wont_be_empty
  end

  it 'handles classes as describe args' do
    class_code = <<~RUBY
      class MyClass; end
      describe MyClass do
        it "works" do
          assert_rematch "ok"
        end
      end
    RUBY

    res = Rematch::Source.new(class_code).index
    class_code_2 = class_code.gsub('MyClass', 'OtherClass')
    res_2 = Rematch::Source.new(class_code_2).index
    _(res[4].first).wont_equal res_2[4].first
  end

  it 'distinguishes diverse describe arguments' do
    mixed_code = <<~RUBY
      describe MyClass do; it("1"){ assert_rematch "1" }; end
      describe MyModule::MyClass do; it("1"){ assert_rematch "1" }; end
      describe :symbol do; it("1"){ assert_rematch "1" }; end
      describe "string" do; it("1"){ assert_rematch "1" }; end
      describe Class.new do; it("1"){ assert_rematch "1" }; end
    RUBY

    res = Rematch::Source.new(mixed_code).index
    shas = res.values.flatten
    _(shas.uniq.size).must_equal 5
  end

  it 'normalizes assertion syntax (assert vs expect vs spec)' do
    code = <<~RUBY
      class Normalize
        def test_syntax
          assert_rematch("data")
          expect("data").to_rematch
          _("data").must_rematch
        end
      end
    RUBY

    res = Rematch::Source.new(code).index
    sha_assert = res[3].first
    sha_expect = res[4].first
    sha_spec   = res[5].first

    _(sha_assert).must_equal sha_expect
    _(sha_expect).must_equal sha_spec
  end

  it 'implements smart dot logic (ignoring dots before rematch methods)' do
    code = <<~RUBY
      class SmartDot
        def test_dots
          # Identical lines below (comments stripped from line numbering in source)
          # L5
          expect(x).to_rematch
          # L7
          assert_rematch(x)
          # L9
          expect(x) . to_rematch
        end
      end
    RUBY

    res = Rematch::Source.new(code).index

    sha_expect = res[5].first
    sha_assert = res[7].first
    sha_space  = res[9].first

    _(sha_expect).must_equal sha_assert
    _(sha_assert).must_equal sha_space
  end

  it 'handles extra arguments and command calls' do
    code = <<~RUBY
      class ExtraArgs
        def test_args
          _(array).must_rematch :assert_equal_unordered
          assert_rematch char, label: "assert_ID"
          expect(char).to_rematch label: "to_ID"
        end
      end
    RUBY

    res = Rematch::Source.new(code).index
    # Verify these lines are found and have IDs
    _(res[3].first).wont_be_nil
    _(res[4].first).wont_be_nil
    _(res[5].first).wont_be_nil
  end

  it 'returns empty hash on syntax error' do
    bad_code = "class Broken < end"
    res = Rematch::Source.new(bad_code).index
    _(res).must_be_empty
  end
end
