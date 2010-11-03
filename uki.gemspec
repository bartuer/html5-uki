# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{uki}
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Vladimir Kolesnikov"]
  s.date = %q{2010-08-26}
  s.default_executable = %q{uki}
  s.description = %q{Project creation, dev server, testing, building for uki apps}
  s.email = %q{voloko@gmail.com}
  s.executables = ["uki"]
  s.extra_rdoc_files = [
    "LICENSE"
  ]
  s.files = [
    ".gitignore",
     ".gitmodules",
     "LICENSE",
     "Rakefile",
     "Readme.rdoc",
     "VERSION",
     "bin/uki",
     "frameworks/jspec/lib/images/bg.png",
     "frameworks/jspec/lib/images/hr.png",
     "frameworks/jspec/lib/images/loading.gif",
     "frameworks/jspec/lib/images/sprites.bg.png",
     "frameworks/jspec/lib/images/sprites.png",
     "frameworks/jspec/lib/images/vr.png",
     "frameworks/jspec/lib/jspec.css",
     "frameworks/jspec/lib/jspec.growl.js",
     "frameworks/jspec/lib/jspec.jquery.js",
     "frameworks/jspec/lib/jspec.js",
     "frameworks/jspec/lib/jspec.shell.js",
     "frameworks/jspec/lib/jspec.timers.js",
     "frameworks/jspec/lib/jspec.xhr.js",
     "java/compiler.jar",
     "java/yuicompressor.jar",
     "lib/uki.rb",
     "lib/uki/builder.rb",
     "lib/uki/include_js.rb",
     "lib/uki/project.rb",
     "lib/uki/routes.rb",
     "lib/uki/config.ru",
     "lib/uki/server.rb",
     "lib/pusher.rb",
     "lib/pusher/app.rb",
     "lib/pusher/channel/amqp.rb",
     "lib/pusher/channel/in_memory.rb",
     "lib/pusher/channel.rb",
     "lib/pusher/deferrable_body.rb",
     "lib/pusher/transport/base.rb",
     "lib/pusher/transport/long_poll.rb",
     "lib/pusher/transport/sse.rb",
     "lib/pusher/transport/xhr_stream.rb",
     "lib/pusher/transport.rb",
     "lib/pusher/version.rb",
     "templates/controller.js.erb",
     "templates/index.html.erb",
     "templates/layout.js.erb",
     "templates/model.js.erb",
     "templates/myapp.js.erb",
     "templates/package.js.erb",
     "templates/spec.html.erb",
     "templates/spec.js.erb",
     "templates/view.js.erb",
     "uki.gemspec"
  ]
  s.homepage = %q{http://github.com/voloko/uki}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{uki development tools}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
      s.add_runtime_dependency(%q<commander>, [">= 4.0.1"])
      s.add_runtime_dependency(%q<jspec>, [">= 3.3.2"])
    else
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<commander>, [">= 4.0.1"])
      s.add_dependency(%q<jspec>, [">= 3.3.2"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<commander>, [">= 4.0.1"])
    s.add_dependency(%q<jspec>, [">= 3.3.2"])
  end
end

