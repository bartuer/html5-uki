require File.join(File.dirname(__FILE__), 'routes.rb')

use Rack::Reloader
use Rack::ShowExceptions
use Rack::CommonLogger

UkiRoutes.run! :host => Uki::Server.host, :port => Uki::Server.port


