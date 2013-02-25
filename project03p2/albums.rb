#!/usr/bin/env ruby
require 'sinatra'
require 'data_mapper'
require_relative 'album'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/albums.sqlite3.db")
set :port, 8080

get "/form" do
	erb :form, :layout => :header
end

post "/list" do
	@sort_order = params['order']
	@rank_to_highlight = params['rank'].to_i
	@albums = Album.all(:order => [ (@sort_order.to_sym).asc ])
	erb :list, :layout => :header	
end