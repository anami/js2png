# js2png

This web app is a utility to compress and then decompress Javascript to and from PNGs
This app is inspired by the work of Jacob Sedelin of [nihilogic.dk](http://nihilogic.dk)

This technique and web app will only work on HTML5 enabled browsers!

## Dependencies

This is a Sinatra based web app and apart from the gems in the Bundler gemfile there's pretty nothing else you'll need.

## Usage

    To run the web app - issue the following:
    > ruby js2png.rb
    
    Or in Linux/Mac environments
    > chmod +x yt2mp3.rb
    > ./js2png.rb

    Then open up your favourite browser (HTML5) compliant of course and point to the following:
    http://localhost:4567
    
## Shotgun

    If you feel that you'd need to edit the file while you are running the app - you might want to install
    the shotgun gem..

    > gem install shotgun
    > shotgun js2png.rb
    * open up your browser pointing to http://localhost:9393

## Caveats

This technique only works on HTML5 enabled web browsers and is not considered for professional projects.
Once all the browsers catch up and everyone's using them - this technique will probably come in to use.
