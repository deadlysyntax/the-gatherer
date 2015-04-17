require 'spec_helper'
require_relative '../lib/outrider/engine.rb'

describe Engine do
  

  it "initializes with processed commands" do
    engine = Engine.new
    expect(engine.commands).to eq({
      :action     => nil, 
      :options    => {
        :domain     => "", 
        :limit      => 1000, 
        :project    => "", 
        :filename   => "", 
        :restrict   => true, 
        :help       => false,
        :set_project=> true
      }
    })
  end
  
  
  
  it "runs the command specified in @commands and passes through options" do
    engine = Engine.new
    
    engine.commands = {
      :action     => "test_method_true", 
      :options    => {
        :domain     => "", 
        :limit      => 1000, 
        :project    => "test_project", 
        :filename   => "", 
        :restrict   => true, 
        :help       => false,
        :set_project=> true
      }
    }
      
    expect( engine.run ).to eq({:domain=>"", :limit=>1000, :project=>"test_project", :filename=>"", :restrict=>true, :help=>false, :set_project => true})
      
  end
  

  
end
