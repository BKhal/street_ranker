# frozen_string_literal: true

require 'elasticsearch'
require 'json'
require 'nokogiri'
require 'open-uri'

client = Elasticsearch::Client.new retry_on_failure: 2, delay_on_retry: 30_000, url: 'http://elasticsearch:9200', log: true
client.cluster.health
language = 'en'
url = "https://game.capcom.com/cfn/sfv/stats/usagerate?lang=#{language}" # URL to pull Street Fighter V stats from
html = URI.parse(url).open
response = Nokogiri::HTML(html)
date_list = response.css('#selectColumn option')

# iterates through every month in dropdown menu
date_list.reverse.each do |dates|
  url_date = dates.attribute('value').value
  url = "https://game.capcom.com/cfn/sfv/stats/usagerate/#{url_date}?lang=#{language}"
  formatted_date = String.new(url_date.to_s).insert(4, '-')
  html = URI.parse(url).open
  response = Nokogiri::HTML(html)
  names = response.css('.name')
  play_rate = response.css('.percent')
  # sends each character's playrate data from the selected month to a new Elasticsearch document
  (0..names.size - 1).each do |i|
    json_builder = "{\"Character\": \"#{names[i].text}\",\"Playrate\": #{play_rate[i].text.to_f},\
    \"Month\": \"#{formatted_date}\"}"
    data = JSON.parse(json_builder)
    id = names[i].text + url_date.to_s
    unless client.exists(index: 'street_ranker', id: id)
      client.index(index: 'street_ranker', id: id, body: data)
    end
  end
end
