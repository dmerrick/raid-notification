#!/usr/bin/env ruby 
# This is my shameful attempt at getting hpricot to take care of
# the e-raids script for me. It doesn't work at all because I don't
# really understand what I am doing.

require 'rubygems'
require 'hpricot'
require 'open-uri'

# uses the "old lineups" page for testing
doc = Hpricot(open("http://www.equil.us/forum/viewforum.php?f=21"))
# wget the page when you work on it to not pound their server
#doc = Hpricot(open("eraids.html"))

# find all forms with a table and iterate through rows 4,5,6
(doc/"form/table/tr")[3..5].each do |i|
	listings = (i/"td/span/a")
  # okay, now we have a listing saved

  # shameless hack
	array = []
	listings.each do |listing|
		array << listing.inner_html
	end

	name,replies,poster,views,date = array
	puts "name: #{name}"
	puts "replies: #{replies}"
	puts "poster: #{poster}"
	puts "views: #{views}"
	puts "date: #{date}"
	puts

  # this doesn't work. run it and compare the values to the site
  # there seems to be something strange when a lineup has >1 pages
end

# all this stuff is saved snippits that I thought might help me
# really its just a trail of crumbs
=begin
(doc/"form/table/tr")[3..5].each do |i|
	(i/"td/span/a").each_with_index do |j,k|
	  p "#{k} #{j.inner_html}" #if i =~ /forumline/
	end
end

(doc/"form/table/tr[3..5]/td/span/a").each_with_index do |k,l|
	  p "#{l} #{k.inner_html}" #if i =~ /forumline/
end

(doc/"form/table/").each do |i|
	p i #if i =~ /forumline/
end

((doc/"table/")[8]/"tr").each do |f|
  p f
end
=end
