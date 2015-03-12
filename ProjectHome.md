I play [WoW](http://worldofwarcraft.com), and when I raid, I have to sign up on a forum posting. This script sends emails whenever there is a new posting in the "_Line-Ups and Sign-Ups_" forum.

## From the forum ##
Hey guys. I'm not entirely sure whether or not any of you are nerds like me, but if you're technically inclined, I figured I'd post a little script I just whipped up.

What it does is spit out all of the currently available line-ups for your raid group, and sends you a notification via email when it sees a new line-up posted.

As a disclaimer, I should mention that I have done no testing as to whether or not the script will work for you. In fact, unless you run Mac OS X or some flavor of Linux, you should probably abandon all hope of using this. I can't support Windows, sorry!

### To Install: ###
  * Copy/paste the code to a text file and save it (I recommend something like "equil.rb").
  * Edit the first couple variables to suit your needs. They begin with dollar signs. If you don't want it to email you, delete the $toList lines.
  * Open a terminal and run `ruby /the/location/you/saved/it`
  * The program should return however many current line-ups are out.
  * If you set up the email correctly, you will get an email for each.

### Notes: ###
If you use a Mac, you'll have to run `sudo postfix start` for the mail functionality to work. It will prompt you for your password. If you use Linux, a mail application is likely running already.

Feel free to ask any questions or make any modifications.