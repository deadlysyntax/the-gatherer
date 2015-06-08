require 'spec_helper'
require_relative '../lib/outrider/sentiment/analyzer.rb'

describe Sentiment do
  
  
  
  it "loads word hash" do
    hash = Sentiment::Helpers::load_sentiment_hash('words.txt')
    expect(hash['abusive']).to eq -0.8125
    expect(hash['good']).to eq 0.639423076923
  end
  
  
  
  it "gives the correct score to a collection of words" do
    #p "Sentiment: " + Sentiment::Analyze::document("Im sorry miss Jackson, I am for real").to_s
  end
  
  

  it "gets the sentiment score of word" do
    expect(Sentiment::Analyze::word("fuck")).to eq 0.25
  end
  
  
  it "checks positivity of score" do
    expect( Sentiment::Analyze::positivity( 0.34556 ) ).to eq 1
    expect( Sentiment::Analyze::positivity( 0.0 ) ).to eq 0
    expect( Sentiment::Analyze::positivity( -0.0234 ) ).to eq -1
    
  end
  
  
end