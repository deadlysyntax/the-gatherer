class Stuff < Project
  
  
  
  def initialize
    
    project_name :stuff

  end
  
  
  
  def crawl options
    OutriderTools::Crawl::site( @config, ->(page, uri){
      unless( page.css('.story_landing').text.strip.empty? )
        #p page.css('.story_landing .story__dateline span').empty?
        unless page.css('.story_landing .story__dateline span').empty?
          clean_date = DateTime.strptime( page.css('.story_landing .story__dateline span')[0]["content"], '%a %b %d %H:%M:%S %Z %Y').to_s 
        else
          return { :status  => 'rejected' }
        end
        
        return {
          :url                      => uri.to_s,
          :title_raw                => page.css('.story_content_top h1').text.strip,
          :author                   => page.css('.story__byline span[itemprop="name"]').text.strip,
          :content_raw              => page.css('.story_landing > p').map{ |paragraph| paragraph.text.strip }.to_json,
          :date_published_raw       => page.css('.story_landing .story__dateline span')[0]["content"],
          :date_published_timestamp => clean_date,
          :status                   => 'scraped'
        }
      else
        return { :status  => 'rejected' }
      end
    })
  end
  
  
  
  def intel options
    
    raw_articles = ProjectData.where( "project_id = ? AND content_raw IS NOT NULL", @config[:id] ).limit(10000)
    
    paragraphs   = ''
    words        = []
    
    raw_articles.each do |article|
      paragraphs   += OutriderTools::Clean::word_array_to_string(  JSON.parse( article.content_raw ) ) + ' '
    end
    
    words        = OutriderIntel::word_frequency( OutriderTools::Clean::process_words_to_array( paragraphs ) )
    words        = words.sort_by { |word, frequency| frequency }
      
    p words
    
  end
  
  
  
  


    
  
  
  
  
  
  
  
end