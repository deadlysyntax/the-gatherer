##  Intel is outrider's interface for running 
##  statistical analysis libraries against it's data 
##

module OutriderIntel
  
  
  def self.word_frequency words
    words.inject(Hash.new(0)){|p,v| p[v]+=1; p}
  end
  
  
  
end