class Rt < Project
	def initialize
		project_name :rt
	end
	
	
	def crawl options
	  
	  OutriderTools::Crawl::site(@config, -> (page, url){
	    unless(  page.css('.videoTitle').text.strip.empty? )
	      return {
	        :title_raw                 => page.css('.videoTitle').text.strip,
          :content_raw               => {
            :video_id      => url.to_s.split("/")[3],
            :title         => page.css('.videoTitle').text.strip,
            :url           => url.to_s,
            :thumb_url     => '',
            :views         => '',
            :percent_liked => '',
            :embed_src     => '/_playerrt/redTubePlayer2013.swf?v=' + url.to_s.split("/")[3],
            :categories    => '',
            :tags          => ''
          }.to_json,
          :status                    => 'scraped'
	      }
	    else
	      return {
	        :status => 'rejected'
        }
      end
	    
    })
	  
  end
  
end