#!/usr/bin/env ruby

APP_PATH = File.expand_path(appdir = "/Users/jsugarman/rails_projects/sample_app/config/application",  __FILE__)
require File.expand_path(appdir + "/../boot",__FILE__)
require APP_PATH
# set Rails.env here if desired
Rails.env = 'development'
Rails.application.require_environment!


# 
# require './app/models/user.rb'
# 
u = User.new  name: "rishi", email: "rb@wherever.com", password: "foobar", password_confirmation: "foobar"

puts "created user :" + u.name

u.microposts.build(content: "first post")

puts "micropost content: " + u.microposts.methods.join(',')

# u.save!