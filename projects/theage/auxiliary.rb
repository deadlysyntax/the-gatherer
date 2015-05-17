class Theage < Project
	def initialize
		project_name :theage
	end
	
	
	def crawl options
    p OutriderTools::Crawl::site( @config, ->(page, uri){
      
      unless(  page.css('.cN-headingPage').text.strip.empty?)
        clean_date = ''
        clean_date = DateTime.strptime(page.css('.dtstamp time').text.strip, '%B %d, %Y').to_s unless page.css('.dtstamp time').text.strip.empty?#Tue Mar 03 08:27:23 UTC 2015
        return {
          :title_raw                 => page.css('h1.cN-headingPage').text.strip,
          :author                    => page.css('.authorName a').text.strip,
          :content_raw               => page.css('.articleBody p').map{ |paragraph| paragraph.text.strip }.to_json,
          :date_published_raw        => page.css('.dtstamp time').text.strip,
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