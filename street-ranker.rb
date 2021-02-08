require "open-uri"
require "nokogiri"

language="en"
url = "https://game.capcom.com/cfn/sfv/stats/usagerate?lang=#{language}"
html = URI.open(url)
response = Nokogiri::HTML(html)
names = response.css("p").select{|name| name["class"] == "name"}
playRate = response.css("p").select{|name| name["class"] == "percent"}
(0..names.size-1).each{|i| puts "#{names[i].text}: #{playRate[i].text}"}