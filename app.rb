require 'sinatra'
require 'sinatra/activerecord'
require 'geocoder'
require_relative './config/enviroments'
require_relative 'thelist.rb'
require_relative './Controllers/artist_controller'
require_relative './Controllers/event_controller'
require_relative './Controllers/venue_controller'

get '/' do
  TheList.printPages
end

get '/fetch' do
  TheList.fetchRecent(params[:offset],params[:pages])
end

get '/artists' do
  ArtistController.show_all_json
end

get '/events' do
  content_type :json
  EventController.show_all_json
end

get '/c' do
  EventController.show_count
end

get '/venues' do
  VenueController.show_all_json
end