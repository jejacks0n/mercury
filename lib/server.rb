require 'rubygems'
require 'bundler/setup'
require 'em-websocket'
require 'em-hiredis'

EM.run do
  @channel = EM::Channel.new

  @redis = EM::Hiredis.connect
  puts 'subscribing to redis'
  @redis.subscribe('ws')
  @redis.on(:message){|channel, message|
    puts "redis -> #{channel}: #{message}"
    @channel.push message
  }

  # Creates a websocket listener
  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8081) do |ws|
    puts 'Establishing websocket'
    ws.onopen do
      puts 'client connected'
      puts 'subscribing to channel'
      sid = @channel.subscribe do |msg|
        puts "sending: #{msg}"
        ws.send msg
      end

      ws.send %Q{{"wsinitialize": "#{sid}"}}

      ws.onmessage { |msg|
        @channel.push %Q{{"sid": "#{sid}", "message": #{msg}}}
      }

      ws.onclose {
        @channel.unsubscribe(sid)
      }
    end
  end
end
