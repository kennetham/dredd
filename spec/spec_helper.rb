require 'webmock/rspec'
require 'rack/test'

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

def asset(name)
  File.join(File.dirname(__FILE__), 'assets', name)
end

def asset_contents(path)
  File.read(asset(path))
end
