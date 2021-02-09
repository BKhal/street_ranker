require "open-uri"
require "nokogiri"

language="en"
url = "https://game.capcom.com/cfn/sfv/stats/usagerate?lang=#{language}"
html = URI.open(url)
response = Nokogiri::HTML(html)
dateList = response.css("#selectColumn option")
dateList.each{
    |date|
    textDate = date.text
    urlDate = date.attribute("value").value
    url = "https://game.capcom.com/cfn/sfv/stats/usagerate/#{urlDate}?lang=#{language}"
    html = URI.open(url)
    response = Nokogiri::HTML(html)
    names = response.css(".name")
    playRate = response.css(".percent")
    puts textDate+"\n"
    (0..names.size-1).each{|i| puts "#{names[i].text}: #{playRate[i].text.to_f}"}
}