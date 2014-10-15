#!/usr/bin/env ruby


#
  require 'fileutils'
  mydir = File.expand_path(File.dirname(__FILE__))
  Dir.chdir(mydir)

puts Dir.pwd

#
  unless ENV['BUNDLE_GEMFILE']
    command = "bundle exec ruby tweet_random_blog_post.rb"
    exec(command)
  end

#
  require 'pry'
  require 'twitter'
  require 'nokogiri'
  require 'open-uri'
  require 'sekrets'
  require 'yaml'



#
  sekrets = Sekrets.settings_for("config.yaml.enc")

#
  site        = Nokogiri::HTML(open("http://dojo4.com/blog/ity"))
  random_post = site.css("a.ity-post-link-wrapper").to_a.sample

#
  post_link   = "http://dojo4.com" + random_post.attr("href")
  post_title  = ['"', random_post.css(".ity-post-caption-heading").inner_text.strip, '"'].join
  post_author = random_post.css(".ity-post-caption-author").inner_text.strip

#
  funny_blog_compliment = [
    "We be steady blogging...",
    "Another day, another epic blog post!",
    "We like to write stuff.",
    "Heyo blog world!"
  ].sample

#
  tweet = [
    funny_blog_compliment,
    post_title,
    post_author,
    post_link
  ].join(' ')


#
  twitter = Twitter::REST::Client.new do |config|
    config.consumer_key        = sekrets.consumer_key
    config.consumer_secret     = sekrets.consumer_secret
    config.access_token        = sekrets.access_token
    config.access_token_secret = sekrets.access_token_secret
  end

  twitter.update(tweet)

