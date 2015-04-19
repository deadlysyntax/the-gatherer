# OUTRIDER

### Introduction

**Outrider Data Framework provides structure and tools for collecting, cleaning, storing and analysing data from around the web** 

Outrider's purpose is to provide an easy-to-use programming interface and organisational structure, to create and run tasks that can programmatically visit and collect data sources, interact with and test websites, and also process, clean and store data. Additionally Outrider provides tools for statistical analysis. 

### Features

| Feature | Purpose |
| ------- | ------- |
Data Mining | Outrider provides tools for **collecting**, **cleaning** and **storing data** from the web. 
Statistical Analysis | Outrider provides libraries for running **statistical algorithms** over datasets.
	

## Basic Usage
When working with Outrider, you work within `projects`. Projects are set up by creating the project name as a folder under `lib/projects` and within it, creating a file called `auxiliary.rb`. This is where we configure and write the callbacks specific to each project and the tasks provided between the CLI and the Outrider core. 

In other words, when you crawl a website, you write a method called `crawl_site` which is where you write what you'd like to happen on each page that is crawled (such as retrieving elements through the nokogiri interface and writing it to the database. 

### Projects
To create a full project (including folders and db), call create project and pass a project name, title and domain
> ./lib/ignite.rb create_project -p project -d domain.com

To create just the database entry
> ./lib/ignite.rb create_project_db_row -p project -d domain.com

To delete a project 
> /lib/ignite.rb delete_project -p project

#### auxiliary.rb
Create a new project folder in `lib/projects` and create a file called auxiliary.rb

Inside it create a class with the same name as your project (but capitalized) and have it inherit from Project.

```ruby

class Site < Project
	
	project_name :site
	
	# Here is where you can write your callbacks.
	# All methods in this class must overwrite methods in the interface lib/project which acts as an interface
	def crawl_site
		# Code to crawl site
	end
end

```

### Crawling

Specify project and lets us take over
> ./lib/ignite.rb pick_crawl_scrape -p XXX

Deprecated Command
> ./lib/ignite.rb crawl_site [ [ --project=XXX ] or [  -p XXX ] ]