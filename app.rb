require 'sinatra'
require 'sinatra/activerecord'
require './config/enviroments'
require './thelist.rb'
require './models/model'

get '/' do
  TheList.printPages(5)
end