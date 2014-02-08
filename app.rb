require 'sinatra'
require 'sinatra/activerecord'
require 'geocoder'
require_relative './config/enviroments'
require_relative 'thelist.rb'
require_relative './Controllers/artist_controller'
require_relative './Controllers/event_controller'
require_relative './Controllers/venue_controller'

set :protection, except: :remote_token

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

post '/venues/:id' do
  puts "id : #{params[:id]} lat : #{params[:lat]} long : #{params[:log]}"
  venue = Venue.find(params[:id])
  if venue and params[:lat] and params[:log] 
    venue.latitude = params[:lat]
    venue.longitude = params[:log]
    venue.save
  else
    halt 406
  end
  
end