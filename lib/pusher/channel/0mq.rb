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
    puts "Recieved: -- session[#{@session_id}] <- { channel: #{@channel_id}, content : #{content}}"
    @transport.write content
  end
end

module Pusher
  module Channel
    class ZMQ
      attr_reader :connections

      def initialize(options={})
        @options = options.merge({:topic => ''})
        @connected = false
        @context = EM::ZMQ::Context.new(1)
        @connections = {}
      end
      
      def subscribe(channel_id, session_id, transport)
        connect(channel_id, session_id, transport) unless @connected
      end
      
      def publish(channel_id, message)
      end
      private
      def connect(channel_id, session_id, transport)
        return if @connected
        sock_url = "tcp://#{@options[:host]}:#{@options[:port]}"
        subscriber =  @context.connect :sub, sock_url, MessageHandler, transport, session_id, channel_id
        @connections[session_id.to_sym] = subscriber
        if channel_id
          subscriber.subscribe channel_id
        else
          subscriber.subscribe @options[:topic]
        end

        if subscriber.readable?
          @connected = true
        end
      end
    end
  end
end
