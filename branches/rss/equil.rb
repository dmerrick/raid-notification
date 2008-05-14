#!/usr/bin/env ruby
# This script goes to the Equilibrium website and looks for new raid postings.

require 'open-uri'
require 'rss/maker'

# these variables are editable
# you can use ANY valid email address in fromStr
@group = 1
@log = '~/equilibrium.all.log'


class Array
  # This method is simply a way to save an array as a plaintext file.
  # There are better ways to do this but this was quick and dirty.
  # Idea stolen from O'Reilly's Perl Cookbook.
  def tie(filename, flags)
    File.open(filename, flags) do |file|
      file.each_line { |line| self.push(line.chomp) }
      yield
      file.rewind
      each { |line| line ? file.puts(line) : file.puts("") }
    end
  end
end

# this is the url it is going to look at
url = "http://www.equil.us/forum/viewforum.php?f=17"
# old raids, for testing regexps
#url = "http://www.equil.us/forum/viewforum.php?f=21"


rssVersion = "2.0" # ["0.9", "1.0", "2.0"]
feedLocation = "testFeed.xml" # local file to write
completedRuns = Array.new

rssContent = RSS::Maker.make(rssVersion) do |maker|
  maker.channel.title = "Equilibrium RSS feed"
  maker.channel.link = "http://www.equil.us"
  maker.channel.description = "All Active Raids"
  maker.items.do_sort = true # sort items by date
	  
  completedRuns.tie(@log, File::RDWR|File::CREAT) do
    open(url) do |file|
      file.each do |line|
        if line =~ /row1/ && line =~ /Gr(ou)?p/
	  # cleanup the title
          @lineup = line.sub(/^.*>G/,"G").sub(/(T(ime)?|<).*$/,"Time")
          @lineup.gsub!(/amp;/,"") # removes the gross &amp;
          puts @lineup

	  # extract the url
	  link = "http://equil.us/"
	  #link = line.blah
	  
          unless completedRuns.include?(@lineup.chomp)
	    completedRuns << @lineup
  
	    # our rss feed
	    i = maker.items.new_item
	    i.title = @lineup
	    i.link = link
	    i.date = Time.now
  
          end # unless
        end # if
      end # each
    end # open
    completedRuns.sort! # this is just for aesthetics 
  end # tie
end # rss
  
# write the rss feed
File.open(feedLocation,"w") do |file|
  file.write(rssContent)
end
