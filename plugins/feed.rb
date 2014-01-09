require 'redis'
class Feed
 include Cinch::Plugin
 match /^feed (.*)/i, :use_prefix => false
 def execute(m, *args)
  args = args.join(" ").split(" ")
  username = m.user.user.reverse.chop.reverse
  $r = Redis.new
  def getweight(binkeys, farm, bin, m)
     if binkeys.any?
      binkeys.each do |userbin|
       userbin = (userbin.split":")[2]
       binweight = $r.smembers(binkeys).join
       m.reply "#{farm} #{userbin} #{binweight}"
      end
     elsif farm
      binweight = $r.smembers("bins:#{farm}:#{bin}:pounds").join
      m.reply "#{farm} #{bin} #{binweight}"
     else
      m.reply "The farm #{farm} has no bins. Create them with feed #{farm} <bin number> <pounds>"
     end
  end
  if args[0] == "status"
   userfarms = $r.smembers(username)
   if userfarms.any?
    userfarms.each do |userfarm|
     farmbins = $r.keys("bins:#{userfarm}:*:pounds")
     getweight(farmbins, userfarm, nil, m)
    end
   else
    m.reply "You do not have any bins which you are contacted for, add them with feed <farm number> add me"
   end
  else
   if args[1] == "status"
    farmbins = $r.keys("bins:#{args[0]}:*:pounds")
    getweight(farmbins, args[0], nil, m)
   elsif args[1] == "add"
    if args[2] == "me"
     $r.sadd("bins:#{args[0]}:users", username)
     $r.sadd(username, args[0])
     m.reply "Added your username to #{args[0]}"
    else
     $r.sadd("bins:#{args[0]}:emails", args[2])
     m.reply "Added #{args[2]} to #{args0}"
    end
   elsif args[1] == "remove"
    if args[2] == "me"
     $r.srem("bins:#{args[0]}:users", username)
     $r.srem(username, args[0])
     m.reply "Removed your username from #{args[0]}"
    else
     $r.srem("bins:#{args[0]}:emails", args[2])
     m.reply "Removed #{args[2]} from #{args0}"
    end
   else
    if args[2] == "status"
     getweight(%w{}, args[0], args[1], m)
    elsif args[2] == "settings"
     if args[3] == "size"
      $r.del("bins:#{args[0]}:#{args[1]}:size")
      $r.sadd("bins:#{args[0]}:#{args[1]}:size", args[4])
      m.reply "Size set"
     elsif args[3] == "alert"
      $r.del("bins:#{args[0]}:#{args[1]}:alert")
      $r.sadd("bins:#{args[0]}:#{args[1]}:alert", args[4])
      m.reply "Alert limit set"
     elsif args[3] == "on"
      $r.del("bins:#{args[0]}:#{args[1]}:state")
      $r.sadd("bins:#{args[0]}:#{args[1]}:state", "on")
      m.reply "Feed switched on"
     elsif args[3] == "off"
      $r.del("bins:#{args[0]}:#{args[1]}:state")
      $r.sadd("bins:#{args[0]}:#{args[1]}:state", "off")
      m.reply "Feed switched off"
     else
      m.reply "Size: " + $r.smembers("bins:#{args[0]}:#{args[1]}:size").join
      m.reply "Alert limit: " + $r.smembers("bins:#{args[0]}:#{args[1]}:alert").join
      if $r.smembers("bins:#{args[0]}:#{args[1]}:state").eql?(["on"])
       m.reply "You are taking feed from the bin"
      elsif $r.smembers("bins:#{args[0]}:#{args[1]}:state").eql?(["off"])
       m.reply "You are not taking feed from the bin"
      end
     end
    else
      if args[2].to_i.to_s == args[2]
       $r.del("bins:#{args[0]}:#{args[1]}:pounds")
       $r.sadd("bins:#{args[0]}:#{args[1]}:pounds", args[2])
       m.reply "Number of pounds set"
       if $r.smembers("bins:#{args[0]}:#{args[1]}:alert").empty?
        $r.sadd("bins:#{args[0]}:#{args[1]}:alert", 1000)
       end
       if $r.smembers("bins:#{args[0]}:#{args[1]}:size").empty?
        $r.sadd("bins:#{args[0]}:#{args[1]}:size", 24000)
       end
       if $r.smembers("bins:#{args[0]}:#{args[1]}:rate").empty?
        $r.sadd("bins:#{args[0]}:#{args[1]}:rate", 280)
       end
       if $r.smembers("bins:#{args[0]}:#{args[1]}:state").empty?
        $r.sadd("bins:#{args[0]}:#{args[1]}:state", "off")
       end
      else
       m.reply "Entered pounds is not a number"
      end
    end
   end
  end
 end 
end
