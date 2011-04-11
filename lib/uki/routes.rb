require 'sinatra/base'
require 'uki/builder'
require 'pusher'

class UkiRoutes < Sinatra::Base
  get '/pusher' do
    app = Pusher::App.new(:channel => Pusher::Channel::AMQP.new)
    status, headers, body = app.call(@request.env)
    @response.status = status
    @response.body = body
    @response.headers.merge! headers
    nil
  end
  
  get %r{\.cjs$} do
    
    path = request.path.sub(/(.[yguz])?\.cjs$/, '.js').sub(%r{^/}, './')
    pass unless File.exists? path
    
    response.header['Content-type'] = 'application/x-javascript; charset=UTF-8'
    begin
      if match = request.path.match(/\.y\.cjs$/)
        Uki::Builder.new(path, :compress => true, :compressor  => :yui).code
      elsif match = request.path.match(/\.g\.cjs$/)
        Uki::Builder.new(path, :compress => true, :compressor => :closure).code
      elsif match = request.path.match(/\.u\.cjs$/)
        Uki::Builder.new(path, :compress => true, :compressor => :uglifyjs).code
      elsif match = request.path.match(/\.z\.cjs$/)
        Uki::Builder.new(path, :compress => true).code
      else
        Uki::Builder.new(path).code          
      end
    rescue Exception => e
      message = e.message.sub(/\n/, '\\n')
      "alert('#{message}')"
    end
  end

  get %r{.*} do
    path = request.path.sub(%r{^/}, './')
    path = File.join(path, 'index.html') if File.exists?(path) && File.directory?(path)
    p path
    pass unless File.exists?(path)
    send_file path
  end
end
