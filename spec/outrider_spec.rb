require 'spec_helper'
require_relative '../lib/outrider.rb'

describe Outrider do
  

  it "sets up a blank project on initialization" do
    outrider = Outrider.new
    expect(outrider.project).not_to be nil
  end
  
  
  it "sets up the right project when asked" do
    outrider = Outrider.new
    expect(outrider.project.config).to eq({})
    outrider.set_project_object 'test_project'
    expect(outrider.project.config[:id]).to eq(2)
  end
  
  
  
  it "sets project config[:domain]" do
    outrider = Outrider.new
    outrider.set_project_object 'test_project'
    expect(outrider.project.config[:domain]).to eq("http://outriderapp.com/scrape_test")
  end
  
  
  
  it "cant initialize a project that hasn't been created" do
    outrider = Outrider.new
    expect( outrider.set_project_object 'non_existant_project' ).to be false
  end
  
  
  
  it "calls methods on the project" do
    outrider = Outrider.new
    outrider.set_project_object 'test_project'
    expect( outrider.operate('test_method_true', {}) ).to be true
    expect( outrider.operate('test_method_true', {}) ).to be false
  end
  
  

  
end
