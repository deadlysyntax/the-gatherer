require 'spec_helper'
require_relative '../lib/outrider/tools.rb'

Outrider.new


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




   it "cleans and moves words into an array" do
     dirty_words = "57th 7*(& the whole Thing is R$eally Our's to 67yuhsj 8...,,.87ssd test"
     clean_words = OutriderTools::Clean::process_words_to_array(dirty_words)
     
     expect(clean_words).to eq(["57th", "7*(&", "the", "whole", "thing", "is", "r$eally", "our's", "to", "67yuhsj", "8...,,.87ssd", "test"])
   end




   it "processing words to array doesnt require arguments" do
      clean_words = OutriderTools::Clean::process_words_to_array
      expect(clean_words).to eq([])
  end
  
  
  
  
  it "combines arrays of words into a single string" do
    
    document = "[\"One of New Zealand's wealthiest Maori tribes has just appointed a new temporary boss to head its commercial affairs.\",\"Waikato's Tainui Group Holdings announced chief financial officer, Chris Joblin, is its new acting chief executive.\",\"Joblin steps into the role for outgoing CEO Mike Pohio, who leaves on April 14.\"]"

    result   = OutriderTools::Clean::word_array_to_string( JSON.parse(document) )

    expect( result ).to eq("One of New Zealands wealthiest Maori tribes has just appointed a new temporary boss to head its commercial affairsWaikatos Tainui Group Holdings announced chief financial officer Chris Joblin is its new acting chief executiveJoblin steps into the role for outgoing CEO Mike Pohio who leaves on April 14")
    
  end
  
  
  
end
