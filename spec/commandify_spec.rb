require 'spec_helper'
require_relative '../lib/outrider/commandify.rb'

describe Commandify do
  

  it "sets up commands passed through the command line into a hash" do
    expect(Commandify.process).to eq({
      :action=>"spec", 
      :options    => {
        :domain      => "", 
        :limit       => 1000, 
        :project     => "", 
        :filename    => "", 
        :restrict    => true, 
        :help        => false,
        :set_project => true,
        :intel_command =>""
      }
    })
  end
  
  
  

  
end
