class NzHerald < Project
  

	def initialize
		project_name :nz_herald
		@log = Logger.new(STDOUT)
	end
	

	
	
  def crawl options
    OutriderTools::Crawl::site( @config, ->(page, uri){
      if( ! page.css('.articleTitle').text.strip.empty? )
        return {
          :title_raw           => page.css('.articleTitle').text.strip,
          :author              => page.css('.authorName a').text.strip,
          :content_raw         => page.css('#articleBody p').map{ |paragraph| paragraph.text.strip }.to_json,
          :date_published_raw  => page.css('.storyDate').text.strip,
          :status              => 'scraped'
        }
      else
        return {
          :status              => 'rejected'
        }
      end
    })
  end
  
  
  
  
  
  
  
end


