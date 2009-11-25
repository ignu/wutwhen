require File.dirname(__FILE__) + '/spec_helper'

describe "Sessions" do
  
  describe "When reloading data" do
    it "saves all sessions retrieved from the url" do
    
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
      
      @sessions = Session.parse mash
    end

    it "creates a list with the proper sessions" do
      @sessions.count.should == 2
      @sessions.first.title.should == 
        "The case for Griffon: developing desktop applications for fun and profit"
      @sessions.first.url.should == 
        "/rest/sessions/The-case-for-Griffon-developing-desktop-applications-for-fun-and-profit"
      @sessions.first.abstract.match("Building a desktop application is a").blank?.should == false
      @sessions.first.date.should == DateTime.civil(y=2009, m=2, d=1, h=10, min=0)
      @sessions.first.speaker_name.should=="Andres Almiray"
    end
    
  end
  
end
  
  