#!/usr/bin/ruby
require 'cinch'
bot = Cinch::Bot.new do
 configure do |c|
  c.server = "localhost"
  c.nick = "feedalert-#{ARGV[2]}"
  c.channels = ["#feed"]
 end
end
bot.start
on :join do |m|
 if m.user.user.reverse.chop.reverse = ARGV[2]
  m.user.send("Feed has reached the alert limit for bin number #{ARGV[1]} at farm number #{ARGV[0]}")
  bot.quit
 end
end
