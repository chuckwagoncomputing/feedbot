#!/usr/bin/ruby
require 'cinch'
require '/usr/feed/plugins/help.rb'
require '/usr/feed/plugins/feed.rb'

bot = Cinch::Bot.new do
 configure do |c|
  c.server = "localhost"
  c.nick = "feedbot"
  c.channels = ["#feed"]
  c.plugins.plugins = [Help, Feed]
 end
end
bot.start
