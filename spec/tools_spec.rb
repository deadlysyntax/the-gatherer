require 'spec_helper'
require_relative '../lib/outrider/tools.rb'

describe OutriderTools do
  
  it "crawls a domain" do
   
    project = Project.new
    project.set_config "test_project"
    
    project_record = ProjectData.find_by( url: 'http://outriderapp.com/test/1' )
    project_record.status = 'unscraped'
    project_record.save
    
    callback = ->(page, url){
      return {
        :title_raw                 => page.css('h1.test_class').text.strip,
        :content_raw               => page.css('p.content').map{|paragraph| paragraph.text.strip }.to_json,
        :status                    => 'scraped'
      }
    }
   
   OutriderTools::Crawl::site(project.config, callback )
   
   new_project = ProjectData.find_by( url: "http://outriderapp.com/test/2" )
   expect(new_project).to be_a ProjectData
   expect(new_project.title_raw).to eq("Test 2")
   expect(new_project.status).to eq("scraped")
  end
  
  
  
  
  
  it "scrapes a single page" do
    
    # Delete any existing test pages
    old_project = ProjectData.find_by( url: "http://outriderapp.com/test/2" )
    old_project.destroy unless old_project.nil?
    
    project = Project.new
    project.set_config "test_project"
    
    callback = ->(page, url){
      return {
        :title_raw                 => page.css('h1.test_class').text.strip,
        :content_raw               => page.css('p.content').map{|paragraph| paragraph.text.strip }.to_json,
        :status                    => 'scraped'
      }
    }
    
    data, links = OutriderTools::Scrape::page( project.config[:domain], callback )
    
    expect(data).to eq({:title_raw=>"Test 1", :content_raw=>"[\"This page is no use to you\"]", :status=>"scraped"})
    expect(links[0].to_s).to eq("http://outriderapp.com/test/2")
  
 end
 
 
 
 
 
 it "skips errors when opening a url" do
   
 end
 
 
 

 
 
 
 
 it "tidies urls" do
   project = Project.new
   project.set_config "test_project"
   
   callback = ->(page, url){
     return {
       :title_raw                 => page.css('h1.test_class').text.strip,
       :content_raw               => page.css('p.content').map{|paragraph| paragraph.text.strip }.to_json,
       :status                    => 'scraped'
     }
   }
   
   data, links = OutriderTools::Scrape::page( project.config[:domain], callback )
   
   expect(links[0].to_s).to eq("http://outriderapp.com/test/2")
   expect(links[1]).to be nil
   
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
