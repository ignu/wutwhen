require File.dirname(__FILE__) + '/spec_helper'

describe "Sessions" do
  
  before(:each) do
    @created_sessions = []
  end
  
  after(:each) do
    @created_sessions.each do |s|
      s.destroy
    end   
  end
  
  describe "When getting next sessions" do
    
    before(:each) do
      @past_session = create_session "1/1/2009 09:00"
      @future_session = create_session "1/1/2013 09:00"
    end
      
    it "should not return sessions that have already passed" do
      sessions = Session.upcoming
      sessions.should_not contain(@past_session)
      sessions.should contain(@future_session)
    end
    
    def create_session(date_string)
      session = Session.new
      session.title = "Session #{date_string}"
      session.date = DateTime.parse(date_string)
      session.save!
      @created_sessions << session
      session
    end
      
  end
end


describe "SessionLoader" do
  
  describe "When reloading data" do
    it "saves all sessions retrieved from the url" do
      loader = SessionLoader.new
      session1, session2 = mock(), mock()
      loader.stubs(:parse).returns([session1, session2]) 
      session1.expects :save
      session2.expects :save
      loader.reload
    end  
  end
  
  describe "When loading from XML" do

    before(:all) do
      @session_xml = ""
      file = File.open("sessions.xml", "r")
      while(line = file.gets)
        @session_xml = @session_xml + line
      end
      mash = CodeMash.new
      mash.stubs(:session_url).returns("http://aol.com")
      WebRequest.stubs(:get).returns(@session_xml)
      
      @sessions = SessionLoader.new.parse mash
    end

    it "creates a list with the proper sessions" do
      @sessions.count.should == 2
      first = @sessions.first
      first.title.should == 
        "The case for Griffon: developing desktop applications for fun and profit"
      first.url.should == 
        "/rest/sessions/The-case-for-Griffon-developing-desktop-applications-for-fun-and-profit"
      first.abstract.match("Building a desktop application is a").blank?.should be false
      first.date.should == DateTime.civil(y=2009, m=2, d=1, h=10, min=0)
      first.speaker_name.should == "Andres Almiray"
    end
    
  end
  
end
  
  