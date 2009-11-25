require File.dirname(__FILE__) + '/spec_helper'

describe "Sessions" do
  
  describe "When loading from XML" do

    before(:each) do
      @session_xml = ""
      file = File.open("sessions.xml", "r")
      while(line = file.gets)
        @session_xml = @session_xml + line
      end
      @sessions = Session.parse(@session_xml)
    end

    it "creates a list with the proper sessions" do
      @sessions.count.should == 2
      @sessions.first.title.should == 
        "The case for Griffon: developing desktop applications for fun and profit"
      @sessions.first.url.should == 
        "/rest/sessions/The-case-for-Griffon-developing-desktop-applications-for-fun-and-profit"
      @sessions.first.abstract.match("Building a desktop application is a").blank?.should == false
    end
    
  end
  
end
  
  