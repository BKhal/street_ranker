# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'json'
require 'elasticsearch'

client = Elasticsearch::Client.new log: true
client.cluster.health

language = 'en'
url = "https://game.capcom.com/cfn/sfv/stats/usagerate?lang=#{language}" # URL to pull Street Fighter V stats from
html = URI.parse(url).open
response = Nokogiri::HTML(html)
date_list = response.css('#selectColumn option')
q = 0

# iterates through every month in dropdown menu
date_list.reverse.each do |date|
  q += 1
  text_date = date.text
  next if client.exists(index: "streetranker_#{text_date.delete('/').downcase}", id: q) # next loop if index exists

  url_date = date.attribute('value').value
  url = "https://game.capcom.com/cfn/sfv/stats/usagerate/#{url_date}?lang=#{language}"
  html = URI.parse(url).open
  response = Nokogiri::HTML(html)

  # sends every 'Character: Play rate' pair from selected month to a new Elasticsearch index
  names = response.css('.name')
  play_rate = response.css('.percent')
  json_builder = String.new("{\"#{text_date}\": {")
  puts json_builder
  (0..names.size - 1).each { |i| json_builder += "\"#{names[i].text}\": #{play_rate[i].text.to_f}," }
  json_builder.delete_suffix!(',').concat('}}')
  data = JSON.parse(json_builder)
  client.index(index: "streetranker_#{text_date.delete('/').downcase}", id: q, body: data)
end
