#!/usr/bin/env ruby
require 'rack'
require_relative 'album'
require 'sqlite3'
require 'erb'

class AlbumApp
  def call(env)
    request = Rack::Request.new(env)
    case request.path
    when "/form" then render_form(request)
    when "/list" then render_list(request)
    else render_404
    end
  end
  
  def render_header(response)
		file = ERB.new(File.read("header.html.erb")).result(binding)
		response.write(file)
  end

  def render_form(request)
		response = Rack::Response.new
		render_header(response)		
		file = ERB.new(File.read("form.html.erb")).result(binding)		
		response.write(file)
		response.finish
  end

  def render_list(request)
		response = Rack::Response.new
		render_header(response)		
		db = SQLite3::Database.new( "albums.sqlite3.db" )
		sort_order = request.params['order']		
		rank_to_highlight = request.params['rank'].to_i		
		albums = db.execute( "SELECT * FROM albums ORDER BY #{sort_order}" ) 
		file = ERB.new(File.read("list.html.erb")).result(binding)		
		response.write(file)
		response.finish
  end

  def render_404
    [404, {"Content-Type" => "text/plain"}, ["Nothing here!"]]
  end

end

Signal.trap('INT') { Rack::Handler::WEBrick.shutdown } # Ctrl-C to quit
Rack::Handler::WEBrick.run AlbumApp.new, :Port => 8080