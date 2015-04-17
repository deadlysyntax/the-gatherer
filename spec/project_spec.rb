require 'spec_helper'
require_relative '../lib/outrider/project.rb'

describe Project do
  

  it "initializes with @config set" do
    project = Project.new
    expect(project.config).to eq({})
  end
  
  
  it "sets config from database" do
    project = Project.new
    project.set_config "test_project"
    expect(project.config).to eq({:id=>2, :title=>"test_project", :domain=>"http://outriderapp.com/scrape_test"})
  end

  
  
  
  it "deletes a project from filesystem and database" do
    
    Project::create({ :domain => 'http://temporary.com', :project => 'temporary' })
    Project::delete({ :project => 'temporary' })
    expect( Projects.find_by( title: 'temporary' ) ).to be nil
    expect( File ).not_to exist('../lib/outrider/projects/temporary/auxiliary.rb')
    
  end



  it "sets up a new project in the filesystem and database" do
    
    # Deletes any http://temporary.com project
    #Project::delete({ :project => 'temporary' })
    
    filepath = OutriderTools::Store::get_filepath __FILE__, "../lib/projects/temporary/auxiliary.rb"
    Project::create({ :domain => 'http://temporary.com', :project => 'temporary' })
    expect( Projects.find_by( title: 'temporary' ) ).not_to be nil
    expect( File ).to exist(filepath)
    
    Project::delete({ :project => 'temporary' })
  end

  
end
