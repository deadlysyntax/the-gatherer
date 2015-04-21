# OUTRIDER

### Introduction

**Outrider Data Framework provides structure and tools for collecting, cleaning, storing and analysing data from around the web** 

Built using Ruby and Python, Outrider's purpose is to provide an easy-to-use interface and set of tools to help create and run tasks that can programmatically visit, process, scrape, clean, store, analyse, access and display data from online sources. 

### Features

| Feature | Purpose |
| ------- | ------- |
Visit | 
Data Mining | Outrider provides tools for **collecting**, **cleaning** and **storing data** from the web. 
Statistical Analysis | Outrider provides libraries for running **statistical algorithms** over datasets.
	


### Outline 
#### Command Line Interface
At it's basic level, Outrider provides a command line interface, whose commands give us the ability to call and pass arguments to our API. The Command line is used by running `./lib/ignite.rb`. When you call this file through your shell, you must pass it a command to run and any arguments to pass through to the command. Such as:

```shell
./lib/ignite.rb crawl -p project_name
```

#### API
The commands that can be recognised and run through the CLI form the *Outrider API*. The API sits behind and is accessed through the the command line. Actions that are common to the purposes of Outriders main goals - such as crawling and scraping, are made available publicly by the API and can be called by passing it as the first argument to `./lib/ignite.rb` when using the CLI. In the above example, the word *crawl* is a method of the Outrider API and `-p project_name` tells the API which project to look for the *crawl* implementation.

##### Extending
The API is extensible through the use of `auxiliary.rb` files, which can be specified by each project.

#### Projects
When working with Outrider, you first create and then work within a *project*. You can create as many of these as you want. These let us create custom functionality to handle different jobs uniquely.

Once created, a project consist of a file `./lib/projects/:project_name/auxiliary.rb` which contains a class whose public methods correspond to the CLI commands. 

#### Creating Projects
##### CLI
Projects can be created using the command line
``` shell 
# Creates ./lib/projects/:project_name/auxiliary.rb and adds a record to the projects table in the database, 
# including a seed entry to the raw_data table
./lib/ignite.rb create_project -p project_name

# Just adds a record to the projects table of the database and the seed entry in the raw_data table (doesn't create an auxialiary file)
./lib/ignite.rb create_project_db_row -p project_name -d http://domain.com

# Deletes the project folder and row in the project table of the database
./lib/ignite.rb delete_project -p project_name
```

##### Rake task
Outrider is assumed to run on two machines - a dev and a production server. When you create a new project you do so on the dev server and it gets added to git, however in order to make a project runnable in production, there must be some entries in the database for that. Outrider has a rake command that is run from the dev server which creates the files and db entry on the dev server and also creates the necessary database entries on the production server. 

```shell
rake project:build['project_name','project_domain']
```


#### The process
A call to `./ignite.rb crawl -p test_project` will first check the validity of the command against the API definition, in this case *crawl* is a legitimate API method, since that passes it will then look in `./lib/project/test_project/auxiliary.rb` for a public method called **crawl**
```ruby
# lib/projects/test_project/auxiliary.rb

class TestProject < Project

	def initialize
		project_name :test_project
	end

	def crawl
		OutriderTools::Crawl::site( @config, ->(page, uri){
      		# Use the Nokogiri page object here to do what you want to each page
			# You have full access to the OutriderTools module
			# You inheret all the methods and instance variables defined in the global Project class
			# Which also gives you access to @config which is a hash containing :id, :title and :domain of the project
    	})
	end
end
```



### System Information
Requires Ruby 2.2.1. Outrider is run on two machines. The development machine and the remote server and deployed using Capistrano. 



