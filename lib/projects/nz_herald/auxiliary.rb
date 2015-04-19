class NzHerald < Project
  

	def initialize
		project_name :nz_herald
		@log = Logger.new(STDOUT)
	end
	
	
	#
  # options are passed through from the command line
  #
  def crawl_site options
    

    OutriderTools::Crawl::crawl_site(@config[:domain], 1000) do | page, uri |

      if( ! page.css('.articleTitle').text.strip.empty? )

        data = {
          :url                 => uri.to_s,
          :title_raw           => page.css('.articleTitle').text.strip,
          :author              => page.css('.authorName a').text.strip,
          :content_raw         => page.css('#articleBody p').map{ |paragraph| paragraph.text.strip }.to_json,
          :date_published_raw  => page.css('.storyDate').text.strip,
          :status              => 'scraped',
          :project_id          => @config[:id]
        }
        
        if ProjectData.exists?( url: data[:url] )
          #@log.info ". #{ data[:url] }"
          @log.info "*************************\n Skipping - already got it \n #{data[:url]}"
        else
          ProjectData.create(data)
          @log.info "*************************\n Content Written: #{data[:url]}"
        end
      else 
         @log.info ". #{uri.to_s}"
      end 
      
    end
    
  end
	
end