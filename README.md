# RTOLEDO DEV - Theme for Rail Projects

## A little about

This project only serves as a help for new applications to be created with the basics it should have and say with quality.

## Requirements

- rvm
- rails 7.x
- TDD

### Commands with RVM

To start the project it is always good to use Ruby's version.And for this I advise using [RVM] (https://rvm.io/).So initially a good practice would be to run:

`rvm install 3.2.1`

with this the 3.2.1 version of Ruby will be installed

After it is necessary to install Rails of course, without it did nothing right?!

`gem install rails --no-doc`

and finally create the project following the template with the command below

with importmap

`rails new name_of_project -T -m=template.rb`

sketchy

`rails new name_of_project -j esbuild -T -m=template_esbuild.rb`

## Project commands

- To browse the project enter the folder and execute
- `cd name_of_project`
- `bundle`
- `bind/dev`

- Soon after  `http://localhost:3000`
- To perform tests just run
- `bundle exec guard`
- and then press **Enter**, so all tests will be driven

### Commands with Docker and Docker Compose

