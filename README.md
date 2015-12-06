# OUTRIDER

### Introduction

Outrider provides tools and structure for managing multiple web scraping and data analysis tasks. It provides a command-line interface to a powerful API, useful for collecting, cleaning, storing and analysing data from the web.

Outrider lets you create multiple projects, each relating to a specific domain. Once set up, you use simple commands to run specific tasks for specific projects. 



### How to get started
* Download Outrider using the command line `git clone https://github.com/deadlysyntax/outrider.git` and change into the new directory in your terminal.
* Install dependencies `bundle install`.
* Setup the database by importing ./config/schema.sql into MySQL - `mysql -u username -p database_name < ./config/schema.sql`
* Create the database config file in your home directory `~/.outrider/config/database.yml` for storing environment-based database configuration. 

```yaml
host:     localhost
username: root
password: root
database: outrider
adapter:  mysql2
```

* Create a new project `rake project:build['project_name','http://domain.com']` - giving it a name and the url of the domain you want to work with. This sets up the project in the database and generates a new folder in ./projects. It creates a file called auxiliary.rb within the new project folder.
* In each project's auxiliary.rb file is where we define our functionality specific to that new project (for example, to define what content to pull from each page on a domain).
* Run `./lib/ignite.rb command -p project_name` to initiate each task.



###Auxiliary file

As mentioned above, when you create a new project, Outrider creates a new auxiliary.rb file within the project's folder. This file is where you create the functions that map to the command line interface. If you type `./lib/ignite.rb crawl -p project_name`, Outrider will look for a `crawl` method inside auxiliary.rb and run that function. Within those auxiliary functions, you have access to the full Outrider API. The API provides a range of common functionality.


```ruby  
# creates a new project file
rake project:build['nz_herald','http://nzherald.com']

# /projects/nz_herald/auxiliary.rb

# crawl method maps to the first argument passed to the command line
def crawl options
	# This method is part of the Outrider API, which you have access to within your auxiliary.rb file
	# @config passes our specific project data to the method
	# the second argument is a callback which recieves the Nokogiri page object for every age that it visits. http://www.nokogiri.org/tutorials/searching_a_xml_html_document.html
	OutriderTools::Crawl::site( @config, ->(page, uri){
		# Select elements from the page using css selectors
	  	unless(  page.css('.articleTitle').text.strip.empty? )
			# Do any data processing from the page
	    	clean_date = DateTime.strptime(page.css('.storyDate').text.strip, '%a %b %d %H:%M:%S %Z %Y').to_s #Tue Mar 03 08:27:23 UTC 2015
			# Set the fields that get stored in the database for each page visited
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
```


### How it works
#### Command Line Interface
Outrider's goal is to provide a conventional way to create data scraping projects and run tasks for each project, and to make it so that once a task is created, it's easy to run regularly. Your interface for running tasks is the command line. Here I will describe the anatomy of an Outrider command. 

A command is made of several parts:
```shell
./lib/ignite.rb crawl -p project_name
```

* **Script:**`./lib/ignite.rb` is the core file which processes our commands. This is the script we run. 
* **Command:** `crawl` is the task to run. This part of the command is mapped to a function you define within auxiliary.rb. 
* **Project:** `-p project_name` specifies which project to run. Outrider will look to the functions within the specified project's auxiliary.rb file.

Any functions that you'd like to run via the CLI must be defined in both `commandify.rb` and your project's `auxiliary.rb`. Outrider comes with some predefined commands set up, which you can write functions for in auxiliary.rb, but you can also extend Outrider and define your own

```shell
# in ./lib/outrider/commandify.rb
module Commandify
  def self.process
    # Place custom command options here. See instructions at http://manageiq.github.io/trollop/
    sub_commands << %w()
    # Set these to accept arguments through the command line and pass them to your auxiliary methods
    command_opts = Trollop::options do
      # REQUIRED. Do not mess with the default options. 
      # Do not duplicate arguments or their short form. 
      # Run tests after modifying
      # opt :domain, "The domain", :short => "-d", :type => String, :default => ''


      ############################################ 
	  # CUSTOM. Place custom command options here
	  #
    end
  end
end
```

Any commands listed in the `sub_commands` variable can then be defined within any of your projects' `auxiliary.rb` file and run by specifying it in the CLI call.

So if you were to add a `sentiment` command to the `sub_commands` variable in `./lib/commandify.rb`, then add a `sentiment` method to your projects auxiliary file, you could then run that function by calling `./lib/ignite.rb sentiment -p project_name`.

```ruby
# in ./lib/project/:project_name/auxiliary.rb
def my_own_command( options )
	# Here you have access to the OutriderTools module
	# Also, options is a hash of the commands passed in through CLI
end
```

#### More  on creating CLI commands.
Commands are handled by a gem called Trollop 

*IMPORTANT!* 
* Do not modify the existing Trollop configuration 
* Read the Trollop documentation at http://manageiq.github.io/trollop/
* Put your own configuration in the specified places - see below.
* Always run tests `rspec spec` after modifying this
* TODO - move this functionality into an setup where they don't have to touch commandify.rb


##### In your command line
```shell
 ./lib/ignite.rb my_own_command -p project_name -your_argument_key value
```

###### Options
Once set up in commandify.rb, calling your new method in auxiliary.rb will pass in a hash of the options specified in the command line call. This means your auxiliary methods need to accept the options hash.
```ruby 
def auxiliary_method( options )
  # options contains a hash such as { :project => 'project_name' }
end
```

## The process
A call to `./ignite.rb crawl -p test_project` will 
1. Check the validity of the command against the API definition in **./lib/outrider/commandify.rb**, 
2. In this case **crawl** is a legitimate API method, and since that passes it will then
3. Look in `./lib/project/test_project/auxiliary.rb` for a public method called **crawl**. 
4. If it doesn't find it there, it will look in the global `Project` object
5. It will call **crawl** and pass in all the options specified in the command line (as long as they're set up in commandify)



### The Outrider Tools API
Within the auxiliary function you define, you have access to a powerful API that provides functionality and tools that are common to the purposes of Outriders main goals - such as crawling and scraping.

 
### OutriderTools API
#### Crawl
##### site
```ruby 
OutriderTools::Crawl::site( project, each_page_callback )
```
| Argument | Expected Value | Description |
| -------- | -------------- | ----------- |
**project** | { :id => 0, :title => '', :domain => '' } | A hash of project config values
**each_page_callback** | ->( page, uri ){} | A callback function to run, which gets passed the Nokogiri object and URI for each page

Recursively looks to the ProjectData in the database for the first `status: 'unscraped'` data record for the specified project. While at each page, it will run the callback and pass it the Nokogiri::HTML object and the current URI. It builds a list of sanitized urls and adds them as ProjectData rows in the database. Thus, recursively filtering through an entire domain and acting on each page

http://www.rubydoc.info/github/sparklemotion/nokogiri

________________________________

#### Scrape
```ruby 
OutriderTools::Scrape::page( url, operate )
```
| Argument | Expected Value | Description |
| -------- | -------------- | ----------- |
**url** | "http://domain.com" | A url to scrape
**operate** | ->( page, uri ){} | A callback function to run, which gets passed the Nokogiri object and URI for each page

Will go to the URL and run the callback and pass it the Nokogiri::HTML object and the current URI. 

http://www.rubydoc.info/github/sparklemotion/nokogiri

________________________________
# Analysis Tools

## Sentiment Analysis


## Frequency


# Projects
When working with Outrider, you first create and then work within a *project*. You can create as many of these as you want. These let us create custom functionality to handle different jobs uniquely.


#### Creating Projects
##### CLI
Projects can be created using the command line
``` shell 
# Creates ./lib/projects/:project_name/auxiliary.rb 
#and adds a record to the projects table in the database, 
# including a seed entry to the raw_data table
./lib/ignite.rb create_project -p project_name

# Just adds a record to the projects table of the database 
#and the seed entry in the raw_data table (doesn't create an auxialiary file)
./lib/ignite.rb create_project_db_row -p project_name -d http://domain.com

# Deletes the project folder and row in the project table of the database
./lib/ignite.rb delete_project -p project_name
```

##### RAKE
Outrider is assumed to run on two machines - a dev and a production server. When you create a new project you do so on the dev server and it gets added to git, however in order to make a project runnable in production, there must be some entries in the database for that. Outrider has a rake command that is run from the dev server which creates the files and db entry on the dev server and also creates the necessary database entries on the production server. 

```shell
rake project:build['project_name','project_domain']
```

#### Customizing Projects
Once created, a project consist of a file `./lib/projects/:project_name/auxiliary.rb` which contains a class whose public methods correspond to the CLI commands. 


#### Tests
```shell
# in project root ./
rspec spec
```

