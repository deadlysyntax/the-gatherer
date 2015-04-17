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

  

  
end
