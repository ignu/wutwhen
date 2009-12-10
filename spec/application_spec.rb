require File.dirname(__FILE__) + '/spec_helper'

describe "When viewing open spaces" do
  include Rack::Test::Methods
  
  describe "it should return all open spaces" do
    @open_spaces = []
    Session.stubs(:all).returns(@open_spaces)
    it { should assign_to @sessions, :equals=>@open_spaces }
  end
end
