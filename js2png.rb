#! /usr/bin/ruby
# js2png
# Javascript to PNG compression utility
#
# Inspired by Jacob Seidelin of nihilogic.dk
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
    data = nil
    size = 0

    if (params[:file] && params[:file][:tempfile])
        # user uploaded a file
        tmpfile = params[:file][:tempfile]
        data = tmpfile.read()
        size = tmpfile.size
        if (size > 262144)
            @message = "File is too big.."
            data = nil
            return haml :index
        end    
    else
        # user filled in the textbox
        data = params[:source]
        if (data.length > 0)
            size = data.length
        else
            data = nil
            @message = "No text entered or file selected."
        end
    end

    # if there is no data then stop..    
    if (!data) then return haml :index end
    
    begin
        # create the PNG
        # calculate the size we need..
        width = Math.sqrt(size).ceil
        height = width

        img = ChunkyPNG::Image.new(width, height)
        #puts data

        # convert each character into a colour and place them in the right place in the image.
        i=0
        (0...height).each do |y|
            (0...width).each do |x|
                begin 
                    color = data[i].ord || 0
                rescue
                    # sometimes data[i] seems to be nil
                    color = 0
                end
                img[x,y] = ChunkyPNG::Color.rgb(color, color, color)
                i+=1
            end
        end

        # save the image - in 8-bit colour
        img.save("public/image.png", :color_mode => ChunkyPNG::COLOR_INDEXED, :bit_depth => 8, :compression => Zlib::BEST_COMPRESSION)
        @uploaded = true        
        @message = "Conversion complete"
    rescue => e
        @uploaded = false
        @message = "Could not create image.. Try again"
        puts e
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
    %textarea(id="source" name="source")   
    %input(type="submit" value="Convert!")
- if @uploaded
    %img{:src=>"image.png", :id=>"png"}
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
    %h2 What you need to do now
    .step
        .title Step 1
        %p Save the image above (Right click and select save as.)
    .step
        .title Step 2
        %p Save the javascript below (Right click and select save as.)
        %a(href="pngdata.js") PngData.js
    .step
        .title Step 3
        %p Copy and paste the following javascript to load the PNG as Javascript:
        .code 
            loadPNGData("image.png", function(d) {eval(d);});
        
@@stylesheet
body
    font-family: "Lucida Grande", sans-serif
    font-size: 12px
    background: #f1f1f1
h1,h2,h3,h4,h5,h6
    font-family: "Helvetica", sans-serif
    margin: 0
h1
    font-size: 48pt
    letter-spacing: -0.05em
h4
    font-size: 24pt
h1.title
    color: #ccc
    margin-top: -67px
h4.subtitle
    color: #ccc
#container
    width: 600px
    margin: 57px auto 3px
    padding: 5px
    background: #fff
    border: 5px solid #ccc
    -moz-border-radius: 10px
    -webkit-border-radius: 10px
    border-radius: 10px
textarea    
    width: 100%
    height: 300px
#footer
    width: 600px
    margin: 0 auto
    text-align: center
    color: #888
    a
        :color #888
.message
    padding: 2px
    border-radius: 10px
    -webkit-border-radius: 10px
    -moz-border-radius: 10px
    background-color: #333
    color: white
    border: solid 2px #333
.step
    padding: 6px
    border-radius: 10px
    -webkit-border-radius: 10px
    -moz-border-radius: 10px
    color: #333
    border: dotted 2px #666
    margin-bottom: 6px
    .title
        font-size: 120%
