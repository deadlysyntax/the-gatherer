require 'spec_helper'
require_relative '../lib/outrider/tools.rb'

describe OutriderIntel do
  
  
  it "checks a document for word frequency" do
    cleaned_words    = %w{one of new zealand wealthiest maori tribes has just appointed jas of of of has}
    
    frequency_table = OutriderIntel::word_frequency cleaned_words
    
    expect(frequency_table).to eq({
      "one"        => 1, 
      "of"         => 4, 
      "new"        => 1, 
      "zealand"    => 1, 
      "wealthiest" => 1, 
      "maori"      => 1, 
      "tribes"     => 1, 
      "has"        => 2, 
      "just"       => 1, 
      "appointed"  => 1, 
      "jas"        => 1
    })
  end
  
  
  
end