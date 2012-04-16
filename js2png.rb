#! /usr/bin/ruby
# js2png
# Javascript to PNG compression utility
#
# Inspired by Jacob Sedelin of nihilogic.dk
# by anamii
require 'rubygems'
require 'sinatra'
require 'sass'
require 'haml'
require 'chunky_png'

set :haml, :format => :html5

get "/" do
    @title = "JS2PNG"
    haml :index
end

post "/" do
    @message = nil
    unless params[:file] &&
        (tmpfile = params[:file][:tempfile]) &&
        (name = params[:file][:filename])
        @message = "No file selected"
        return haml :index
    end
    
    size = tmpfile.size
    if (size > 262144)
        @message = "File is too big.."
        return haml :index
    end
    
    begin
        # create the PNG
        # calculate the size we need..
        width = Math.sqrt(size).ceil
        height = width

        img = ChunkyPNG::Image.new(width, height)
        data = tmpfile.read()
        #puts data

        # convert each character into a colour and place them in the right place in the image.
        i=0
        (0...height).each do |y|
            (0...width).each do |x|
                color = data[i] || 0
                img[x,y] = ChunkyPNG::Color.rgb(color, color, color)
                i+=1
            end
        end
        img.save("public/image.png", :color_mode => ChunkyPNG::COLOR_INDEXED, :bit_depth => 8, :compression => Zlib::BEST_COMPRESSION)
        @uploaded = true        
        @message = "Upload complete"
    rescue
        @uploaded = false
        @message = "Could not create image.. Try again"
    end

    haml :index
end

get '/stylesheet.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :stylesheet
end

__END__

@@layout
!!! 5
%html
    %head
        %title JS2PNG
        %link{:rel => "stylesheet", :href => "/stylesheet.css", :type => "text/css" }
        %script{:type => "text/javascript", :src => "/pngdata.js" }
    %body
        #container= yield
        #footer
            powered by
            %a{:href => "http://github.com/anami"} anami!

@@index
%h1.title JS2PNG
%h4.subtitle
    Javascript to PNG compression
- if @message
    %p.message #{@message}
%form(method="post" action="/" enctype="multipart/form-data")
    %input(type="file" id="file" name="file")
    %br
    %input(type="submit" value="Convert!")
- if @uploaded
    %img{:src=>"image.png", :id=>"png"}
    %textarea(id="source" cols="80" rows="15")   
    :javascript
        window.onload = function(){ 
            loadPNG();
        };
		
        function loadPNG() {
            var file="image.png";
            var source=document.getElementById("source");
            loadPNGData(file, function(d) {
                source.value=d;
            });
        }
    %button(onclick="loadPNG();") Reparse
	
@@stylesheet
body
    :font-family "Lucida Grande", sans-serif
    :font-size 12px
    :background #f1f1f1
h1,h2,h3,h4,h5,h6
    :font-family "Helvetica", sans-serif
    :margin 0
h1
    :font-size 48pt
    :letter-spacing -0.05em
h4
    :font-size 24pt
h1.title
    :color #ccc
    :margin-top -67px
h4.subtitle
    :color #ccc
#container
    :width 600px
    :margin 57px auto 3px
    :padding 5px
    :background #fff
    :border 5px solid #ccc
    :-moz-border-radius 10px
    :-webkit-border-radius 10px
    :border-radius 10px
#footer
    :width 600px
    :margin 0 auto
    :text-align center
    :color #888
    a
        :color #888
.message
    :padding 2px
    :border-radius 10px
    :-webkit-border-radius 10px
    :-moz-border-radius 10px
    :background-color #333
    :color white
    :border solid 2px #333
