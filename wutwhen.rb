require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'hpricot'
require 'open-uri'
require 'cgi'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/wutwhen.db")

before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get "/" do
  @sessions = Session.upcoming
  haml :sessions
end

class SessionLoader
  def parse(conference=CodeMash.new)
    sessions = []
    data = Hpricot.parse WebRequest.get(conference.session_url)
 
    data.search("//session").each do |s|
       session = Session.new
       map = conference.mappings
       session.title = s.get(map[:title])
       session.url = s.get(map[:url])
       session.abstract = s.get(map[:abstract])
       session.date = s.get_date(map[:date])
       session.speaker_name = s.get(map[:speaker_name])
       session.room = s.get(map[:room])
       sessions << session
    end
    
    sessions
  end
  
  def reload
    sessions = self.parse CodeMash.new
    sessions.each { |s| s.save }
  end
end

class Session
  
  include DataMapper::Resource
  
  property :id,             Serial
  property :title,          String
  property :abstract,       Text
  property :url,            String
  property :date,           DateTime
  property :speaker_name,   String
  property :room,           String
  
  def self.upcoming
    return Session.all(:date.gt => DateTime.now, :order => [ :date.asc ])
  end
  
  def formatted_abstract
    CGI.unescapeHTML(abstract)
  end
    
end

class CodeMash
  
  def session_url
    "http://codemash.org/rest/sessions"
  end
  
  def mappings
    {:title=>"title", :url=>"uri", :abstract=>"abstract", :date=>"start", :speaker_name=>"speakername", :room=>"room"}
  end
  
end

class Hpricot::Elem
  def get(field)
    puts "getting #{field}"
    element = self.search("/#{field}").first
    if !element.children.nil?
      element.children.first.raw_string.strip
    end
  end
  
  def get_date(field)
    DateTime.strptime get(field) + "+00:00" 
  end
end

class WebRequest
  def self.get(path)
    return open(path)
  end
end

DataMapper.auto_upgrade!
