require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'uki/builder'
require 'pusher'
require 'uki/htmlmin'


class UkiRoutes < Sinatra::Base
  register Sinatra::Reloader

  get '/pusher' do
    app = Pusher::App.new(:channel => Pusher::Channel::AMQP.new)
    status, headers, body = app.call(@request.env)
    @response.status = status
    @response.body = body
    @response.headers.merge! headers
    nil
  end
  
  get %r{\.cjs$} do
    
    path = request.path.sub(/(\.i)?(\.[yguz])?\.cjs$/, '.js').sub(%r{^/}, './')
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

   get %r{\.css$} do
    path = request.path.sub(/\.[my].css$/, '.css').sub(%r{^/}, './')
    pass unless File.exists? path
    response.header['Content-type'] = 'text/css'
    option = {:compress => true, :is_css => true, :is_min_css => request.path.match(%r{\.[my]\.css})}
    if request.path.match(/\.y\.css$/)
      option[:compressor] = :yui
    end
    begin
      Uki::Builder.new(path, option).code
    rescue Exception => e
      message = e.message.sub(/\n/, '\\n')
      "alert('#{message}')"
    end
  end

  get %r{\.[cf]html$} do
    path = request.path.sub(/\.[cf]html$/, '.html').sub(%r{^/}, './')
    pass unless File.exists? path
    response.header['Content-type'] = 'text/html; charset=UTF-8'
    if request.path.match /\.chtml/
      Nokogiri::HTML(open(path)).to_minify_html "#{request.scheme}://#{request.host}", true      
    elsif request.path.match /\.fhtml/
      Nokogiri::HTML(open(path)).to_minify_html "#{request.scheme}://#{request.host}", false
    else
      [500, "text/plain", request.path]
    end
  end

  get %r{\.z\.json$} do
    path = request.path.sub(/\.z\.json$/, '.json').sub(%r{^/}, './')
    pass unless File.exists? path
    response.header['Content-type'] = 'text/json; charset=UTF-8'
    `/usr/local/bin/uki_json_minify #{path}`
  end
  
  get %r{.*} do
    path = request.path.sub(%r{^/}, './')
    path = File.join(path, 'index.html') if File.exists?(path) && File.directory?(path)
    pass unless File.exists?(path)
    affix = path[path.rindex('.')..-1]
    forbid = ['.rb', '.sqlite', '.db']
    if forbid.include?(affix) || path.include?('.git') || path.include?('..')
      p 'access server code ? ' + path
      halt
    else
      p path
    end
    send_file path
  end
end
