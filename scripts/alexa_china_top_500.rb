#!/usr/bin/env ruby

require "bundler/inline"

gemfile do
  source 'https://rubygems.org'
  gem "mechanize"
  gem "pry"
end

agent = Mechanize.new

sites = []
20.times do |n|
  pagination = ";#{n}" if n > 0
  url = "http://www.alexa.com/topsites/countries#{pagination}/CN"
  agent.get(url) do |page|
    sites += page.search(".site-listing .desc-paragraph a").map { |a| a[:href].sub('/siteinfo/', '') }
  end
end

blacklist = %w(
  github.com
  youtube.com
)

puts "# Alieax Top 500 Sites in China without '.cn' (#{Time.now.strftime('%Y%m%d')})"
puts sites.find_all { |site| !site.end_with?(".cn") } - blacklist
