###
#  to run use
#     ruby -I ./lib -I ./test test/test_json.rb
#  or better
#     rake test

require 'helper'


class TestJson < MiniTest::Test

  def test_all
    names = [
             'jsonfeed.json',
             'byparker.json',
             'daringfireball.json',
             'inessential.json',
             'spec/json/example.json',
             'spec/json/microblog.json',
            ]

    names.each do |name|
      assert_feed_tests_for( name )
    end
  end

end # class TestJson
