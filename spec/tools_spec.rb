require 'spec_helper'
require_relative '../lib/outrider/tools.rb'

describe OutriderTools do
  
  it "crawls a domain" do
   
   #project = Project.find_by(
   #callback = ->(page, url){
     
   #}
   
   #OutriderTools::Crawl::site('test_project', callback )
  end
  
  
  
  
  
  it "scrapes a single page" do
    project = Project.new
    project.set_config "test_project"
    
    callback = ->(page, url){
      return {
        :title_raw                 => page.css('h1.test_class').text.strip,
        :content_raw               => page.css('p.content').map{|paragraph| paragraph.text.strip }.to_json
        :status                    => 'scraped'
      }
    }
    
    data, links = OutriderTools::Scrape::page( project.config[:domain], callback )
    
    p "################"
    p data
    p links
    #expect(data).to eq({})
  
 end
 
 
 
 
 it "saves urls to database" do
   
 end
 
 
 
 
 it "tidies urls" do
   
 end
 
 
 
 
 
 it "returns a full filepath to file + specified file" do
   filepath =  OutriderTools::Store::get_filepath '/var/outrider/test.rb', 'spec/test.rb'
   expect(filepath).to eq("/var/outrider/spec/test.rb")
 end
 
 
 it "returns a filename excluding the current folder" do
    filepath =  OutriderTools::Store::get_filepath '/var/outrider', 'spec/test.rb'
    expect(filepath).to eq("/var/spec/test.rb")
  end
 
 
 it "returns an array of image filetypes" do
   image_filetypes = OutriderTools::Clean::file_types :images
   expect(image_filetypes).to eq(['png','jpeg','jpg','gif','svg'])
 end
 
  it "defaults return an array of all filetypes" do
     image_filetypes = OutriderTools::Clean::file_types
     expect(image_filetypes).to eq(['png','jpeg','jpg','gif','svg','txt','js','css','zip','gz','pdf'])
   end


  
end
