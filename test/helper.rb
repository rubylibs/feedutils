## $:.unshift(File.dirname(__FILE__))


## minitest setup

require 'minitest/autorun'

require 'logutils'
require 'textutils'
require 'fetcher'


## our own code

require 'feedparser'


LogUtils::Logger.root.level = :debug


## add custom assert
module MiniTest
class Test

  def assert_feed_tests_for( name )
    b = BlockReader.from_file( "#{FeedParser.root}/test/feeds/#{name}" ).read

    ## puts "  [debug] block.size: #{b.size}"

    xml   = b[0]
    tests = b[1]

    feed = FeedParser::Parser.parse( xml )

    tests.each_line do |line|
      if line =~ /^[ \t]*$/
        next        ## skip blank lines
      end

      line = line.strip

      pos = line.index(':')   ## assume first colon (:) is separator
      expr  = line[0...pos].strip    ## NOTE: do NOT include colon (thus, use tree dots ...)
      value = line[pos+1..-1].strip


      ##  for ruby code use |>  or >> or >>> or =>  or $ or | or RUN or  ????
      ##   otherwise assume "literal" string

      if value.start_with? '>>>'
         value = value[3..-1].strip
         code="assert_equal #{value}, #{expr}"
      elsif value.start_with? 'DateTime'         ## todo/fix: remove; use >>> style
        code="assert_equal #{value}, #{expr}"
      else # assume value is a "plain" string
        ## note use %{ } so value can include quotes ('') etc.
        code="assert_equal %{#{value}}, #{expr}"
      end

      puts "eval #{code}"
      eval( code )
    end  # each line
  end

end
end # module MiniTest



def fetch_and_parse_feed( url )
  xml = Fetcher.read( url )

  FeedParser::Parser.parse( xml )
end
