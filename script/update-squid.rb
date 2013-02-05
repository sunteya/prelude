#!/usr/bin/env ruby

SCRIPT_PATH = File.absolute_path $0
RAILS_ROOT = File.expand_path "../..", SCRIPT_PATH
require File.join(RAILS_ROOT, "config/environment.rb")

Bind.assign_ports

SQUID_CONFIG = "/etc/squid3/squid.conf"
SQUID_BIN = "/usr/sbin/squid3"

SQUID_LINE_START = "# ====== PRELUDE START ======"
SQUID_LINE_END = "# ====== PRELUDE END ======"


squid_config = File.read(SQUID_CONFIG)

config_ports = "#{SQUID_LINE_START}\n"
User.available.map(&:binding_port).compact.uniq.sort.each do |port|
  config_ports << "http_port #{port}\n"
end
config_ports << "#{SQUID_LINE_END}\n"


new_squid_config = squid_config.dup
if (open_pos = squid_config.index(SQUID_LINE_START))
  new_squid_config = squid_config[0, open_pos]
end
new_squid_config << config_ports
if (close_pos = squid_config.index(SQUID_LINE_END))
  new_squid_config << squid_config[close_pos + SQUID_LINE_END.length + 1, squid_config.length]
end


if new_squid_config != squid_config
  File.open(SQUID_CONFIG, "w") do |f|
    f << new_squid_config
  end
  `#{SQUID_BIN} -k reconfigure`
end

