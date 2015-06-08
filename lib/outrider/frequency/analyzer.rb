module Frequency
  
  
  
  module Analyze
    
    
    def self.articles( raw_articles )
      paragraphs   = ''
      words        = []

      raw_articles.each do |article|
        paragraphs   += OutriderTools::Clean::word_array_to_string(  JSON.parse( article.content_raw ) ) + ' '
      end

      words        = Frequency::Tools::word_frequency( OutriderTools::Clean::process_words_to_array( paragraphs ) )
      words.sort_by { |word, frequency| frequency }
    end
    
    #
  end
  
  
  
  
  
  module Tools
    
    def self.word_frequency words
      words.inject(Hash.new(0)){|p,v| p[v]+=1; p}
    end
    
    
    #
    
  end
  
  
  
end