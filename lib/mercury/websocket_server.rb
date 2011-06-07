module Mercury
  class WebsocketServer

    def initialize
      @channel = EM::Channel.new
      @publisher = EM::Hiredis.connect
      init_subscriber
    end

    def init_subscriber
      @subscriber = EM::Hiredis.connect
      @subscriber.psubscribe('mercury:*')
      @subscriber.on(:pmessage) do |channel, message|
        @channel.push "{channel: #{channel}, message: #{message}}"
      end
    end

    def start
      puts 'Booting WebsocketServer'
      puts 'Listening on 0.0.0.0:8080, CTRL+C to stop'

      EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080, :debug => true) do |ws|
        ws.onopen do
          sid = @channel.subscribe do |msg|
            ws.send "{sid: #{sid}, packet: #{msg}"
          end

          ws.onmessage do |msg|
            @publisher.publish "{sid: #{sid}, packet: #{msg}}"
          end

          ws.onclose do
            @channel.unsubscribe(sid)
          end
        end
      end
    end

  end
end