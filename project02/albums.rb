require 'rack'
require 'cgi'

class TopAlbums
  def call(env)
	request = Rack::Request.new(env)
	case request.path
	when "/form" then send_form(request)
	when "/list" then send_list(request)
	when "/list.css" then serve_styling(request)
	else unknown_request
	end
  end
  
  def serve_styling(request)
	response=Rack::Response.new
	File.open("list.css","rb"){ |css| response.write(css.read) }
	response.finish
  end
  
  def send_form(request)
	response=Rack::Response.new
	#File.open("form.html","rb"){ |form| response.write(form.read) }
	formArray=[]
	formIndex=0
	File.foreach('form.html'){ |line|
		formArray[formIndex]=line
		formIndex+=1
	}
	0.upto(18){ |i| response.write(formArray[i])	}
	1.upto(100){ |num| response.write("<option value=\"#{num}\">#{num}</option>\n") }
	19.upto(23){ |i| response.write(formArray[i]) }
	response.finish
  end
  
  def unknown_request
	[404, {"Content-Type" => "text/plain"}, ["ERROR 404: Page Not Found"]]
  end
  
  def send_list(request)
	response=Rack::Response.new
	getArray=request.GET()
	htmlArray=[]
	htmlIndex=0
	File.foreach('list.html'){ |line|
		htmlArray[htmlIndex]=line
		htmlIndex+=1
	}
	sorting=getArray["order"]
	rankToHighlight=Integer(getArray["rank"])
	songsList=[]
	rankIndex=0
	File.foreach('top_100_albums.txt') { |line| 
		songsList[rankIndex] = "#{rankIndex+1}\t #{line}"
		rankIndex+=1
	}
	for i in 0..11
		response.write(htmlArray[i])
	end
	case sorting
	when "rank" 
		response.write("<p>Sorted by Rank</p>")
		response.write("<table>\n")
		songsList.each do |line| 
			rank=line[/\d+/]
			year=line[/\d\d\d\d/]
			song=line[/[^\d|\s].*[^\s]/]
			rowString=""
			if Integer(rank) == rankToHighlight
				rowString="<tr id=\"highlight\">\n"
			else
				rowString="<tr>\n"
			end
			response.write(rowString)
			response.write("<td>#{rank}</td>\n")
			response.write("<td>#{song}</td>\n")
			response.write("<td>#{year}</td>\n")
			response.write("</tr>\n")
		end
	when "name"
		
		songsList.sort!{ |first,second|
			firstPart=first[/[^\d|\s].*/]
			secondPart=second[/[^\d|\s].*/]
			firstPart <=> secondPart
		}
		
		response.write("<p>Sorted by Name</p>")
		response.write("<table>\n")
		songsList.each do |line| 
			rank=line[/\d+/]
			year=line[/\d\d\d\d/]
			song=line[/[^\d|\s].*[^\s]/]
			
			rowString=""
			if Integer(rank) == rankToHighlight
				rowString="<tr id=\"highlight\">\n"
			else
				rowString="<tr>\n"
			end
			response.write(rowString)
			response.write("<td>#{rank}</td>\n")
			response.write("<td>#{song}</td>\n")
			response.write("<td>#{year}</td>\n")
			response.write("</tr>\n")
		end
	when "year"
		songsList.sort!{ |first,second|
			firstPart=first[/\d\d\d\d/]
			secondPart=second[/\d\d\d\d/]
			firstPart <=> secondPart
		}
		

		response.write("<p>Sorted by Year</p>")
		response.write("<table>\n")
		songsList.each do |line| 
			rank=line[/\d+/]
			year=line[/\d\d\d\d/]
			song=line[/[^\d|\s].*[^\s]/]
			
			rowString=""
			if Integer(rank) == rankToHighlight
				rowString="<tr id=\"highlight\">\n"
			else
				rowString="<tr>\n"
			end
			response.write(rowString)
			response.write("<td>#{rank}</td>\n")
			response.write("<td>#{song}</td>\n")
			response.write("<td>#{year}</td>\n")
			response.write("</tr>\n")
		end
	else unknown_request
	end
	response.write("</table>\n")
	for i in 12..14
		response.write(htmlArray[i])
	end
	response.finish
  end
end

Rack::Handler::WEBrick.run TopAlbums.new, :Port => 8080