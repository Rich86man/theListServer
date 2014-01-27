require 'sinatra'
require 'sinatra/activerecord'
require_relative './config/enviroments'
require_relative 'thelist.rb'
require_relative './models/model'
require_relative './Controllers/artist_controller'
require_relative './Controllers/event_controller'
require_relative './Controllers/venue_controller'

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

get '/venues' do
  VenueController.show_all_json
end