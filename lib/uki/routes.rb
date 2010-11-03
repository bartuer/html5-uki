require 'sinatra/base'
require 'uki/builder'
require 'pusher'

class UkiRoutes < Sinatra::Base
  set :static, enable
  
  get '/pusher' do
    app = Pusher::App.new(:channel => Pusher::Channel::AMQP.new)
    status, headers, body = app.call(@request.env)
    @response.status = status
    @response.body = body
    @response.headers.merge! headers
    nil
  end
  
  get %r{\.cjs$} do
    path = request.path.sub(/\.cjs$/, '.js').sub(%r{^/}, './')
    pass unless File.exists? path
    
    response.header['Content-type'] = 'application/x-javascript; charset=UTF-8'
    begin
      Uki::Builder.new(path, :optimize => false).code
    rescue Exception => e
      message = e.message.sub(/\n/, '\\n')
      "alert('#{message}')"
    end
  end
end
