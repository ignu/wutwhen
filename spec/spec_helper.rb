
require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'test/unit'
require 'rack/test'

require 'spec'
require 'spec/autorun'
require 'spec/interop/test'
require 'mocha'
require 'shoulda'


# set test environment
Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :raise_errors, true
Sinatra::Base.set :logging, false


require 'application'

def contain(element) 
  simple_matcher("contain #{element}") do |actual|
    match_found = false
    actual.each do |item| 
      match_found = true if item.id == element.id 
    end
    match_found
  end
end


Spec::Runner.configure do |config|
  config.mock_with :mocha
end
