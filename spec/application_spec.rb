require File.dirname(__FILE__) + '/spec_helper'

describe "When viewing open spaces" do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application.new
  end
  
  describe "should be able to get the list of open spaces" do

    it "should return an open spaces form" do
      get '/admin/openspaces'
      last_response.ok?.should be true
    end
    
  end
  
end
