iikoto
------

iikoto is an imageboard written in ruby with sinatra!
it's meant to be a replacement for vichan/kusaba/oh gosh those horrible legacy scripts

it tries to be good at security [citation needed]

the style is based on steinuil's negoto and stein has worked with me to
make the interface look acceptable. thanks stein.

the requirements are:
- gem 'sinatra'
- gem 'sqlite3' # For ActiveRecord's sqlite support (I think)
- gem 'activerecord'
- gem 'sinatra-flash'
- gem 'slim'
- gem 'sass'
- gem 'mini_magick'
- gem 'rack_csrf'
- gem 'mimemagic'

screenshot
----------
could be out of date, but here's how it looks
![screenshot](/screenshot.png)
