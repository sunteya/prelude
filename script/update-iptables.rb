#!/usr/bin/env ruby

require "active_support/all"

@root =  File.expand_path("../..", __FILE__)
@input_rules = `iptables -L INPUT -n`

def exist?(ip)
  @input_rules =~ /ACCEPT.*#{ip}\s/
end

def drop(ip)
  `iptables -D INPUT -s #{ip} -j ACCEPT`
end

def accept(ip)
  `iptables -I INPUT -s #{ip} -j ACCEPT` if !exist?(ip)
end

Dir["#{@root}/allow/*"].each do |path|
  ip = File.basename(path)
  next if ip =~ /^\./
  
  if File.mtime(path) < Time.now - 12.hours
    drop ip
    puts "FileUtils.rm_rf(path)"
  else
    accept ip
  end
end
