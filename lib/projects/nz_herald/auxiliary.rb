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
  
  
  
  
  
  
  
end


