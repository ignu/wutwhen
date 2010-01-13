require File.dirname(__FILE__) + '/spec_helper'

describe "When viewing open spaces" do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application.new
  end
  
  describe "should be able to get the list of open spaces" do

    before(:each) do
      @open_spaces = [Session.new]
      @open_spaces.first.title = "Fred"
      Session.expects(:open_spaces).returns(@open_spaces)
    end
    
    it "should return an open spaces form" do
      get '/admin/openspaces'
      
      last_response.ok?.should be true
      last_response.body.should match 'Open Spaces'
      last_response.body.should match 'Fred'
    end

  end
  
  describe "saving a new open space" do

    before(:each) do
    end
    
    it "should return an open spaces form" do
      hash = {:session => {:title=>"Being cool", :date=>"1/1/2009"}}
      session = stub(:session)
      Session.expects(:new).returns(session)
      session.expects(:save!)
      post '/admin/openspaces', hash
    end

  end
  
  describe "getting open spaces rss" do
    it "should return an open space rss feed" do
      get '/openspaces'
      last_response.ok?.should be true
      last_response.body.should match '<StartDate>2011-02-01T10:00:00</StartDate>'
    end
  end
  
  
  
end
