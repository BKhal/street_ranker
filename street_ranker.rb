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
id = 0

# iterates through every month in dropdown menu
date_list.reverse.each do |dates|
  url_date = dates.attribute('value').value
  url = "https://game.capcom.com/cfn/sfv/stats/usagerate/#{url_date}?lang=#{language}"
  formatted_date = url_date.to_s.insert(4, '-')
  html = URI.parse(url).open
  response = Nokogiri::HTML(html)
  names = response.css('.name')
  play_rate = response.css('.percent')
  # sends each character's playrate data from the selected month to a new Elasticsearch document
  (0..names.size - 1).each do |i|
    json_builder = "{\"Character\": \"#{names[i].text}\",\"Playrate\": #{play_rate[i].text.to_f},\
    \"Month\": \"#{formatted_date}\"}"
    data = JSON.parse(json_builder)
    client.index(index: 'street_ranker', id: id, body: data)
    id += 1
  end
end
