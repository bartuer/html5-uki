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
      Rack::Handler::Thin.run(UkiRoutes,
                              :Host => Uki::Server.host,
                              :Port => Uki::Server.port,
                              :config => File.join(File.dirname(__FILE__), 'config.ru')) { |server|
        trap 'INT' do
          server.respond_to?(:stop!) ? server.stop! : server.stop
        end
      }
    end
  end
end
