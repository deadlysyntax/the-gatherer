##  Intel is outrider's interface for running 
##  statistical analysis libraries against it's data 
##

module OutriderIntel
  
  
  def self.word_frequency words
    
    
    p = words.inject(Hash.new(0)){|p,v| p[v]+=1; p}
    #split_words =  words.each do |word|
      
      
    #  { :word => word, :count => word.count
      
    #end
    
    
  end
  
  
  
end