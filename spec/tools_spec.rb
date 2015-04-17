require 'spec_helper'
require_relative '../lib/outrider/tools.rb'

describe OutriderTools do
  

  it "crawls a given domain" do
    OutriderTools::Crawl::crawl_site( 'http://wetheelusive.com', 1 ) do | page, uri |
      expect(uri).to be_a(URI)
      expect(page).to be_a(Nokogiri::HTML::Document)
    end
  end
  
  


  

  
end
