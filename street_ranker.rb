# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

language = 'en'
url = "https://game.capcom.com/cfn/sfv/stats/usagerate?lang=#{language}"
html = URI.parse(url).open
response = Nokogiri::HTML(html)
date_list = response.css('#selectColumn option')
date_list.each do |date|
  text_date = date.text
  url_date = date.attribute('value').value
  url = "https://game.capcom.com/cfn/sfv/stats/usagerate/#{url_date}?lang=#{language}"
  html = URI.parse(url).open
  response = Nokogiri::HTML(html)
  names = response.css('.name')
  play_rate = response.css('.percent')
  puts text_date
  (0..names.size - 1).each { |i| puts "#{names[i].text}: #{play_rate[i].text.to_f}" }
end
