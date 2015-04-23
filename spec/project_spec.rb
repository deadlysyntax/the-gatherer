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
    expect(project.config).to eq({:id=>2, :title=>"test_project", :domain=>"http://outriderapp.com/test/1"})
  end

  
  
  
  it "deletes a project from filesystem and database" do
    Project::create_folder({ :domain => 'http://temporary.com', :project => 'temporary' })
    Project::create_db_row({ :domain => 'http://temporary.com', :project => 'temporary' })
    Project::delete({ :project => 'temporary' })
    expect( Projects.find_by( title: 'temporary' ) ).to be nil
    expect( File ).not_to exist('../lib/outrider/projects/temporary/auxiliary.rb')
    
  end



  it "sets up a new project in the filesystem" do
    filepath = OutriderTools::Store::get_filepath __FILE__, "../lib/projects/temporary/auxiliary.rb"
    Project::create_folder({ :domain => 'http://temporary.com', :project => 'temporary' })
    expect( File ).to exist(filepath)
    Project::delete({ :project => 'temporary' })
  end
  
  
  
  it "sets up a new project in the database" do
    Project::create_db_row({ :domain => 'http://temporary.com', :project => 'temporary' })
    expect( Projects.find_by( title: 'temporary' ) ).to be_a Projects 
    Project::delete({ :project => 'temporary' })
  end
  
end
