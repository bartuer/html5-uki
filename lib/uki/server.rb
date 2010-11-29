require 'rack'

module Uki
  class Server
    @@host = 'localhost'
    @@port = 21119 # 21 u, 11 k, 9 i

    def self.host
      @@host
    end

    def self.port
      @@port
    end
    
    def initialize hoststr
      @port ||= @@port 
      @host, @port  = (hoststr || @@host).split(':')
      @@port = @port if @port
      @@host = @host if @host
    end
    
    def start!
      server  = Rack::Server.new :Port => @port, :Host => @host, :config => File.join(File.dirname(__FILE__), 'config.ru')
      server.start
    end
  end
  
end
