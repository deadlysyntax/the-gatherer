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
          clean_date = ''
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
        return {
          :status  => 'rejected'
        }
      end
    })
  end
  
  
  
  


    
  
  
  
  
  
  
  
end