require File.join(File.dirname(__FILE__), '..', 'wutwhen.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'spec'
require 'spec/autorun'
require 'spec/interop/test'
require 'mocha'
require 'shoulda'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

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
