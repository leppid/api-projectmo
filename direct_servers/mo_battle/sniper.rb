require 'uri'
require 'net/http'
require 'json'

class Sniper
  def initialize
    @notified = {}
    run
  end

  def run
    fork { exec 'mpg123', '-q', './notify.mp3' }
    puts "############################## SNIPER ACTIVE ##############################\n\n"
    loop do
      snipe
      sleep 0.5
    end
  end

  def snipe
    url = URI('https://api-mainnet.magiceden.dev/v2/collections/pawsvouchers/listings?max_price=0.02&sort=listPrice')

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request['accept'] = 'application/json'

    response = http.request(request)
    body = response.read_body

    if body != '[]'
      if body[0] == '['
        notify(body)
      else
        puts body
      end
    end
  end

  def notify(body)
    data = JSON.parse(body)[0]
    return if @notified[data['tokenMint']]

    fork { exec 'mpg123', '-q', './notify.mp3' }
    puts "############################## SNIPER NOTIFY ##############################\n\n"
    puts "#{data}\n\n"
    @notified[data['tokenMint']] = true
  end
end

Sniper.new
