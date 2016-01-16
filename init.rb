require 'rubygems'
require 'telegram/bot'
require 'ip_info'

token = '152628097:AAH8T0o6Aq9bKQCkS_fI3-36Gl5-XUADrOs'
@ip_info = IpInfo::API.new(api_key: ENV["IP_INFO_KEY"])

def get_address_form(message)
  message[/([\d.]+|(?:https?:\/\/)?(?:[\w]+\.)?[\w]+\.[\w]+)/]
end

def get_info(address, type)
  return 'Error: Address is invalid' unless address

  data = ''
  @ip_info.lookup(address, type: type).map do |e|
    data << e.first.to_s.gsub(/_/, ' ').capitalize + ': ' + e.last + "\n"
  end
  data
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id,
                          text: "Hello, #{message.from.first_name}")
    when /\/city [\w\W]+/
      bot.api.send_message(chat_id: message.chat.id,
                          text: get_info(get_address_form(message.text), 'city') )
    when /\/country [\w\W]+/
      bot.api.send_message(chat_id: message.chat.id,
                          text: get_info(get_address_form(message.text), 'country') )
    end
  end
end