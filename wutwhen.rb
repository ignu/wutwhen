require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'hpricot'
require 'open-uri'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/wutwhen.db")
DataMapper.auto_upgrade!

before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get "/" do
 
end


class Session
  
  include DataMapper::Resource
  
  property :id,             Serial
  property :title,          String
  property :abstract,       Text
  property :url,            String
  property :date,          DateTime
  property :created_at,     DateTime
  property :updated_at,     DateTime
  property :speaker_name,   String
  
  def self.parse(conference=CodeMash.new)
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
       sessions << session
    end
    sessions
  end
  
end

class CodeMash
  
  def session_url
    "http://codemash.org/rest/sessions"
  end
  
  def mappings
    {:title=>"title", :url=>"uri", :abstract=>"abstract", :date=>"start", :speaker_name=>"speakername"}
  end
  
end

class Hpricot::Elem
  def get(field)
    self.search("/#{field}").first.children.first.raw_string.strip
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
