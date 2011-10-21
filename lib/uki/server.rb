require 'thin'
require 'rack'
require File.join(File.dirname(__FILE__), 'routes.rb')

module Uki
  class Server
    @@host = '0.0.0.0'
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
      app = Rack::Builder.app do
        use Rack::Deflater
        run UkiRoutes.new
      end
      server = ::Thin::Server.new(
                         Uki::Server.host,
                         Uki::Server.port,
                         app) 
      server.start
    end
  end
end
