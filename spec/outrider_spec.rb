require 'spec_helper'
require_relative '../lib/outrider/outrider.rb'

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
  
  
  
  
  it "calls methods on the project with options" do
    outrider = Outrider.new
    outrider.set_project_object 'test_project'
    expect( outrider.operate('test_method_true', {:test=>'pass'}) ).to eq({:test=>'pass'})
  end
  
  
  
  
  it "calls methods on the project without options" do
    outrider = Outrider.new
    outrider.set_project_object 'test_project'
    expect( outrider.operate('test_method_false') ).to be false
  end
  
  
  
  
  
  it "wont call a project method that doesn't exist" do
    outrider = Outrider.new
    outrider.set_project_object 'test_project'
    expect( outrider.operate('noexistant_method') ).to eq "Method doesn't exist"
  end
  
  
  
  
  
  it "calls super project method if not in auxiliary file" do
    outrider = Outrider.new
    outrider.set_project_object 'test_project'
    expect( outrider.operate('test_super') ).to eq "Super Test Called"
  end
  
  
  
  
  
  it "loads config from yaml" do
    outrider = Outrider.new
    expect( outrider.config ).not_to be nil
    expect( outrider.config[:messages]['no_method'] ).to eq "Method doesn't exist"
  end
  
  
  
  
  
  it "loads database connecton" do
    outrider = Outrider.new
    expect( outrider.db ).not_to be nil
  end
  

  
end
