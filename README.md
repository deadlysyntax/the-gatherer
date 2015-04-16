# OUTRIDER

### Introduction

**Outrider Web Automation Framework provides structure and tools for writing web-automation tasks** 

Outrider's purpose is to provide an easy-to-use programming interface and organisational structure, to create and run tasks that can automatically visit, interact with and test websites and also that process, clean and store data at URLs. 

Outrider tasks are set-up in *project* files which give you access to inbuilt javascript libraries and an API. Tasks specified in the project files are then run from the command line.

### Features

| Feature | Purpose |
| ------- | ------- |
Interacting with websites. | Outrider provides a framework for interacting with CasperJS, which lets you write complex website interactions  - giving you the full power over the DOM with javascript and jQuery to mimic human behaviours such as filling in forms and clicking links. Useful for **testing website front-ends** and  **downloading website contents**.
Data Mining | Outrider provides tools for **collecting**, **cleaning** and **storing data** from the web. 
Statistical Analysis | Outrider provides libraries for running **statistical algorithms** over datasets.
	

## Basic Usage

### Crawling

> ./lib/ignite.rb crawl_site [ [ --project=XXX ] or [  -p XXX ] ]