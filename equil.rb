#!/usr/bin/env ruby -wKU
# This script goes to the Equilibrium website and looks for new raid postings.

# It will return all current posts for your raid group, and emails you a
# notification whenever a new raid is posted. To prevent duplicate emails,
# it stores all raids that it has seen at the end of the file

require 'open-uri'
require 'net/smtp'

# these variables are editable
# you can use ANY valid email address in $fromStr
$ignoreGroup = 2
$fromStr = 'Dana Merrick <dana@equil.us>'
$toList = ['Dana Merrick <dana.merrick@trincoll.edu>',
           'Dana Cell <9788950017@vtext.com>',
           'Morgan T McClure <morgan.mcclure@case.edu>']


class Array
  # This method reads from the DATA section of this file, which
  # in Ruby is marked by __END__. It takes each line and pushes
  # it into the calling array, yields the code block and writes 
  # the array, one element per line, to the end of the file,
  # starting at the beginning of the DATA block. Idea stolen
  # from O'Reilly's Perl Cookbook.
  def tie()
    DATA.each_line { |line| self.push(line.chomp) }
    yield
    # open the file for writing
    File.open(__FILE__,File::RDWR) do |file|
      # look through the file for the DATA section
      file.each_line do |line|
        break if line =~ /^__END__$/
      end
      # write to the file
      each { |line| line ? file.puts(line) : file.puts("") }
    end
  end
  
  # This method shifts the first n elements out of an array.
  # I'm actually not 100% sure this is working correctly when
  # it is called at the end of the script.
  def shiftN!(n)
    n.times{self.shift}
  end
end

# This method sends an email. For the default values, an MTA (such as
# postfix) must be running, otherwise you must specify details for an
# external server.
# authtype is the authentication type, one of :plain, :login, or :cram_md5.
def sendEmail(address='localhost', port = nil, helo = 'localhost.localdomain',
             user = nil, password = nil, authtype = nil)
  begin # catching errors
    Net::SMTP.start(address,port,helo,user,password,authtype) do |smtp|
      fromAddr = $fromStr.sub(/^.*</,"").sub(/>.*$/,"")
      # SMTP#open_message_stream can take a splat as the second
      # parameter, but I did it this way to preserve the pretty
      # 'Person Name <email@addr.ess>' formatting.
      $toList.each do |toStr|
        toAddr = toStr.to_s.sub(/^.*</,"").sub(/>.*$/,"")
        smtp.open_message_stream(fromAddr,toAddr) do |f|
          f.puts "From: #$fromStr"
          f.puts "To: #{toStr}"
          f.puts "Subject: #$lineup"
          f.puts # the body follows
          f.puts "Time to sign up!"
        end # open_message_stream
      end # each
    end # start
  rescue
    STDERR.print "Mail sending failed: " + $! + "\n"
    # raise # uncomment this for debugging
  end # begin
end

# this is the url it is going to look at
url = "http://www.equil.us/forum/viewforum.php?f=17"
# old raids, for testing regexps
#url = "http://www.equil.us/forum/viewforum.php?f=21"

# time to start the script!
# notice that the whole script is inside the tie() &block
completedRuns = Array.new
completedRuns.tie() do
  open(url) do |file|
    file.each do |line|
      if line =~ /[^\.]topictitle/ && line !~ /[Gg]r(ou)?p #{$ignoreGroup.to_s}/
        $lineup = line.sub(/^.*topictitle">/,"").sub(/<\/.*$/,"")
        $lineup.gsub!(/amp;/,"") # removes the gross &amp;
        puts $lineup
        unless completedRuns.include?($lineup.chomp)
          completedRuns.push($lineup)
          sendEmail if defined? $toList && !$toList.empty?
        end # unless
      end # if
    end # each
  end # open

  # remove the oldest entries if the array is getting big
  completedRuns.shiftN!(completedRuns.size/2) if completedRuns.size >= 10
end # tie

# Previous raids are kept below this __END__ block. You needn't
# worry about the filesize, the script prunes itself.
__END__
25 Man Line-Up: Sunday April 20th at 7pm Server Time
Group 1 Karazhan Line-Up: Wednesday Apr. 16th at 7pm ST
Karazhan Line-Up: Wednesday April 23rd at 7 pm Server Time
Zul'Aman Line-Up: Tuesday April 22 at 7:30 pm Server Time
25 Man Line-Up: Sunday April 27th at 7pm Server Time
Possible  ZA Run on Friday
ZA Lineup Friday April 25th 8:00pm Server Time
