class NzHerald < Project
  

	def initialize
		project_name :nz_herald
		@log = Logger.new(STDOUT)
	end
	
  
	
	
  def crawl options
    OutriderTools::Crawl::site( @config, ->(page, uri){
      unless(  page.css('.articleTitle').text.strip.empty? )
        clean_date = DateTime.strptime(page.css('.storyDate').text.strip, '%a %b %d %H:%M:%S %Z %Y').to_s #Tue Mar 03 08:27:23 UTC 2015
        return {
          :title_raw                 => page.css('.articleTitle').text.strip,
          :author                    => page.css('.authorName a').text.strip,
          :content_raw               => page.css('#articleBody p').map{ |paragraph| paragraph.text.strip }.to_json,
          :date_published_raw        => page.css('.storyDate').text.strip,
          :date_published_timestamp  => clean_date,
          :status                    => 'scraped'
        }
      else
        return {
          :status              => 'rejected'
        }
      end
    })
  end
  
  
  
  def intel options
    
    #raw_articles = ProjectData.where( "project_id = ? AND content_raw IS NOT NULL", @config[:id] ).limit(10000)
    #p Frequency::Analyze::articles( raw_articles )
    
    
    raw_articles = ProjectData.where( "project_id = ? AND content_raw IS NOT NULL", @config[:id] ).limit(10)
    
    paragraphs   = ''
    words        = []

    raw_articles.each do |article|
      #paragraphs   += OutriderTools::Clean::word_array_to_string(  JSON.parse( article.content_raw ) ) + ' '
      text = OutriderTools::Clean::word_array_to_string(  JSON.parse( article.content_raw ) )
      p Sentiment::Analyze::document( text )
      p "\n\n" 
      
    end

    #p paragraphs
    #p "***********"
    #words        = Frequency::Tools::word_frequency( OutriderTools::Clean::process_words_to_array( paragraphs ) )
    #words.sort_by { |word, frequency| frequency }
    
  end
  
  
  
  
  
  
  
  
  
  def reddit options
    
    p 'stuf'# Redditbot::get_subscribes
    
    
    
  end
  
  
  
end


