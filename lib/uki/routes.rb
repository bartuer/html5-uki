require 'sinatra/base'
require 'uki/builder'
require 'pusher'
require 'uki/htmlmin'

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
    
    path = request.path.sub(/(.i)?(.[yguz])?\.cjs$/, '.js').sub(%r{^/}, './')
    pass unless File.exists? path
    
    response.header['Content-type'] = 'application/x-javascript; charset=UTF-8'
    option = {}
    begin
      if match = request.path.match(/\.y\.cjs$/)
        option = {:compress => true, :compressor  => :yui}
      elsif match = request.path.match(/\.g\.cjs$/)
        option = {:compress => true, :compressor  => :closure}
      elsif match = request.path.match(/\.u\.cjs$/)
        option = {:compress => true, :compressor  => :uglifyjs}
      elsif match = request.path.match(/\.z\.cjs$/)
        option = {:compress => true}
      else
        option = { }
      end
      if match = request.path.match(/\.i\.[yguz]\.cjs$/)
        option.merge! :indent => true
      end
      Uki::Builder.new(path, option).code
    rescue Exception => e
      message = e.message.sub(/\n/, '\\n')
      "alert('#{message}')"
    end
  end

  get %r{\.chtml$} do
    path = request.path.sub(/\.chtml$/, '.html').sub(%r{^/}, './')
    pass unless File.exists? path
    response.header['Content-type'] = 'text/html; charset=UTF-8'
    Nokogiri::HTML(open(path)).to_minify_html "#{request.host}:#{request.port}"
  end
  
  get %r{.*} do
    path = request.path.sub(%r{^/}, './')
    path = File.join(path, 'index.html') if File.exists?(path) && File.directory?(path)
    p path
    pass unless File.exists?(path)
    send_file path
  end
end
