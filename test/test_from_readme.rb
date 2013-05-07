
require 'jellyfish/test'
require 'stringio'

describe 'from README.md' do
  readme = File.read(
             "#{File.dirname(File.expand_path(__FILE__))}/../README.md")
  codes  = readme.scan(
    /### ([^\n]+).+?``` ruby\n(.+?)\n```\n\n<!---(.+?)-->/m)

  codes.each.with_index do |(title, code, test), index|
    if title =~ /NewRelic/i
      warn "Skip NewRelic Test" unless Bacon.kind_of?(Bacon::TestUnitOutput)
      next
    end
    should "pass from README.md #%02d #{title}" % index do
      method_path, expect = test.strip.split("\n", 2)
      method, path        = method_path.split(' ')

      status, headers, body = Rack::Builder.new do
        eval(code)
      end.call('REQUEST_METHOD' => method, 'PATH_INFO' => path,
               'rack.input'     => StringIO.new)

      body.extend(Enumerable)
      [status, headers, body.to_a].should.eq eval(expect, binding, __FILE__)
    end
  end
end
