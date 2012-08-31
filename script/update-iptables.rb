#!/usr/bin/env ruby

require "active_support/all"
IPTABLES = "/sbin/iptables"
ROOT =  File.expand_path("../../", __FILE__)

INPUT_RULES = `#{IPTABLES} -L INPUT -n`

def exist?(ip)
  INPUT_RULES =~ /ACCEPT.*#{ip}\s/
end

def drop(ip)
  if exist?(ip)
    command = "#{IPTABLES} -D INPUT -s #{ip} -j ACCEPT"
    puts command
    `#{command}`
  end
end

def accept(ip)
  if !exist?(ip)
    command = "#{IPTABLES} -I INPUT -s #{ip} -j ACCEPT"
    puts command
    `#{command}`
  end
end

Dir["#{ROOT}/allow/*"].each do |path|
  ip = File.basename(path)
  next if ip =~ /^\./
  
  if File.mtime(path) < Time.now - 12.hours
    drop ip
    puts "FileUtils.rm_rf(path)"
  else
    accept ip
  end
end
