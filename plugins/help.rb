class Help
 include Cinch::Plugin
 match /^[hH]elp/i, :use_prefix => false
 def execute(m)
  m.reply <<TEXT
Usage:
feed <farm number> status
    Gets status for all bins at <farm number>
feed <farm number> <bin number> status
    Gets status for <bin number> at <farm number>
feed status
    Gets status for all farms your username gets notifications for
feed <farm number> <bin number> <pounds>
    Update how full the bin is
feed <farm number> add me
    Adds your username to the list so you can get notified when you join this room if a bin at <farm number> gets past alert limit
feed <farm number> remove me
    Removes your username from the list
feed <farm number> add <email address>
    Adds an email to the list to be notified when a bin at <farm number> gets past alert limit
      also: see http://www.makeuseof.com/tag/email-to-sms
feed <farm number> remove <email address>
    Removes email from the list
feed <farm number> <bin number> settings on
feed <farm number> <bin number> settings off
    Sets whether or not you are currently taking feed out of the bin
feed <farm number> <bin number> settings size <pounds>
    Sets how many pounds the bin can hold
feed <farm number> <bin number> settings alert <pounds>
    Sets alert limit
feed <farm number> <bin number> settings
    Shows all settings
TEXT
 end
end
