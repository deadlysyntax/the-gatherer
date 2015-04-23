require 'sinatra'



get '/' do
  "Outrider reporting for duty"
end

get '/test/1' do
  "<a href='http://outriderapp.com/test/2'>Link</a>"
end

get 'test/2' do
  "<a href='http://outriderapp.com/test/1'>Link</a>"
end