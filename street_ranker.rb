# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'json'

language = 'en'
url = "https://game.capcom.com/cfn/sfv/stats/usagerate?lang=#{language}"
html = URI.parse(url).open
response = Nokogiri::HTML(html)
date_list = response.css('#selectColumn option')
json_builder = String.new('{')
date_list.each do |date|
  text_date = date.text
  url_date = date.attribute('value').value
  url = "https://game.capcom.com/cfn/sfv/stats/usagerate/#{url_date}?lang=#{language}"
  html = URI.parse(url).open
  response = Nokogiri::HTML(html)
  names = response.css('.name')
  play_rate = response.css('.percent')
  json_builder.concat("\"#{text_date}\": {")
  (0..names.size - 1).each { |i| json_builder += "\"#{names[i].text}\": #{play_rate[i].text.to_f}," }
  json_builder.delete_suffix!(',').concat('},')
end
json_builder.delete_suffix!(',').concat('}')
data = JSON.parse(json_builder)
puts data
