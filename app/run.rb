require 'sinatra'



get '/' do
  "Outrider reporting for duty"
end

get '/test/1' do
  "<h1 class='test_class'>Test 1</h1><a href='http://outriderapp.com/test/2'>Link</a><br /><p class='content'>This page is no use to you</p>"
end

get '/test/2' do
  "<h1 class='test_class'>Test 2</h1><a href='http://outriderapp.com/test/1'>Link</a><a href='http://google.com'>External Link</a><a href='http://outriderapp.com/test/test.pdf'>Internal File Link</a><a href='http://google.com/test.pdf'>External File Link</a><br /><p class='content'>This page is no use to you</p>"
end