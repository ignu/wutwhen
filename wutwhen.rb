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
  
  def self.parse(xml)
    sessions = []
    data = Hpricot.parse(xml)
 
    data.search("//session").each do |s|
       session = Session.new
       session.title = s.get("title")
       session.url = s.get("uri")
       session.abstract = s.get("abstract")
       session.date = s.get_date("start")
       session.speaker_name = s.get("speakername")
       sessions << session
    end
    sessions
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
