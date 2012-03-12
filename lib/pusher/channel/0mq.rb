require 'rubygems'
require 'eventmachine'
require File.join(File.expand_path('../../../eventmachine', __FILE__), 'zmq.rb') 

module MessageHandler
  def initialize(transport, session_id, channel_id)
    @transport = transport
    @session_id = session_id
    @channel_id = channel_id
  end
  
  def receive_data(data)
    content = data.split(Regexp.new(@channel_id+'\s+'))[1]
    @transport.write content
  end
end

module Pusher
  module Channel
    class ZMQ
      attr_reader :connections

      def initialize(options={})
        @options = options.merge({:topic => ''})
        @context = EM::ZMQ::Context.new(1)
        @connections = {}
      end
      
      def subscribe(channel_id, session_id, transport)
        if @connections[session_id.to_sym] == nil
          sock_url = "tcp://#{@options[:host]}:#{@options[:port]}"
          subscriber =  @context.connect :sub, sock_url, MessageHandler, transport, session_id, channel_id
        else
          subscriber = @connections[session_id.to_sym]
        end

        EM.next_tick do
          EM.next_tick do
          if subscriber.notify_readable?
            channel = channel_id ? channel_id : @options[:topic]
            subscriber.subscribe channel
            @connections[session_id.to_sym] = subscriber
          end
          end
        end
      end

      def unsubscribe(session_id)
        if @connections[session_id.to_sym]
          @connections[session_id.to_sym].close
          @connections.delete(session_id.to_sym)
        end
      end
      
      def publish(channel_id, message)
      end
    end
  end
end
