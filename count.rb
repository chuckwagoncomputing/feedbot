#!/usr/bin/ruby
require 'redis'
require 'cinch'
$r = Redis.new
lastloop = $r.smembers("bins:#{ARGV[0]}:#{ARGV[1]}:lastloop")
pounds = $r.smembers("bins:#{ARGV[0]}:#{ARGV[1]}:pounds")
if lastloop.any?
 unless $r.smembers("bins:#{ARGV[0]}:#{ARGV[1]}:pounds") == lastloop
  unless lastloop == pounds
   $r.del("bins:#{ARGV[0]}:#{ARGV[1]}:rate")
   $r.sadd("bins:#{ARGV[0]}:#{ARGV[1]}:rate", lastloop - pounds)
  end
  $r.del("bins:#{ARGV[0]}:#{ARGV[1]}:pounds")
  $r.sadd("bins:#{ARGV[0]}:#{ARGV[1]}:pounds", pounds - rate) unless $r.smembers("bins:#{ARGV[0]}:#{ARGV[1]}:state").join == off
  newpounds = $r.smembers("bins:#{ARGV[0]}:#{ARGV[1]}:pounds")
  if newpounds <= $r.smembers("bins:#{ARGV[0]}:#{ARGV[1]}:alert"
   $r.smembers("bins:#{ARGV[0]}:#{ARGV[1]}:users").each do |username|
    `/usr/feed/alertbot.rb "#{ARGV[0]}" "#{ARGV[1]}" "#{username}" &`
   end
   $r.smembers("bins:#{ARGV[0]}:#{ARGV[1]}:emails").each do |email|
    `/usr/feed/mailer.rb "#{email}" "Feed has reached the alert limit for bin number #{ARGV[1]} at farm number #{ARGV[0]}"`
   end
  end
  $r.del("bins:#{ARGV[0]}:#{ARGV[1]}:lastloop")
  $r.sadd("bins:#{ARGV[0]}:#{ARGV[1]}:lastloop", pounds)
 end
end
