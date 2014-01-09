#!/usr/bin/ruby
unless ARGV[0] == nil
require 'pony'
Pony.options = ({
  :from => 'feedalertbot@gmail.com',
  :via => :smtp,
  :via_options => {
    :address              => 'smtp.example.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => 'email@example.com',
    :password             => 'password',
    :authentication       => :login,
    :domain               => 'public hostname'
  }
})

Pony.mail(:to => ARGV[0], :body => ARGV[1])
else
 puts "Usage: mailer.rb <email address> <body>"
end
