require 'spec_helper'
#require_relative '../lib/ignite.rb'

describe "Ignite" do  
  
  it "starts outrider engine" do
    cmd = `lib/ignite.rb test_super -p test_project 2>&1`
    expect(cmd).to eq "\"Super Test Called\"\n"
  end
  
  
  it "wont run an invalid command" do
    cmd = `lib/ignite.rb invalid_command 2>&1`
    expect(cmd).to eq "Invalid Command\n"
  end
  
  
  it "wont run when no command given" do
    cmd = `lib/ignite.rb 2>&1`
    p cmd
  end
  
  
end



