class TestProject < Project
  
  
  
  def initialize
    
    project_name :test_project

  end
  
  
  
  
  def test_method_true options
    return options
  end
  
  def test_method_false options
    return false
  end
  
  
  

  #
  # options are passed through from the command line
  #
  def crawl_site options
    OutriderTools::Crawl::crawl_site(@config[:domain]) do | page, uri |
      
      if( ! page.css('.story_content_top h1').text.strip.empty?  && ! page.css('.story_landing .story__dateline span')[0].nil? )

        data = {
          :url                 => uri.to_s,
          :title_raw           => page.css('.story_content_top h1').text.strip,
          :author              => page.css('.story__byline span[itemprop="name"]').text.strip,
          :content_raw         => page.css('.story_landing > p').map{ |paragraph| paragraph.text.strip }.to_json,
          :date_published_raw  => page.css('.story_landing .story__dateline span')[0]["content"],
          :status              => 'scraped',
          :project_id          => @config[:id]
        }
        
        if ProjectData.exists?( url: data[:url] )
          puts "*************************"
          puts "Skipping - already got it"
          puts data[:url]
        else
          ProjectData.create(data)
          puts "*************************"
          puts "Content Written: "
          puts data[:url]
        end
      else
         puts "."
      end 
      
    end
    
  end

    
  
  
  
  
  
  
  
end