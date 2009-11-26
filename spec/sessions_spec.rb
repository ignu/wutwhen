require File.dirname(__FILE__) + '/spec_helper'

describe "Sessions" do
  
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

    before(:each) do
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
  
  