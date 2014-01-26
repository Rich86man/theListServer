require 'sinatra'
require 'sinatra/activerecord'
require './config/enviroments'
require './thelist.rb'
require './models/model'
require_relative 'artist_controller'
require_relative 'event_controller'

get '/' do
  TheList.printPages(0)
end


get '/fetch' do
  TheList.fetchRecent
end


get '/artists' do
  ArtistController.show_all_json
end

get '/events' do
  EventController.show_all_json
end