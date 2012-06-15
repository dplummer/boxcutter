# -*- encoding: utf-8 -*-
require File.expand_path('../lib/./version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Donald Plummer"]
  gem.email         = ["donald@cideasphere.com"]
  gem.description   = %q{Wrapper for BlueBoxGroup's API}
  gem.summary       = %q{Wrapper for BlueBoxGroup's API}
  gem.homepage      = "https://github.com/dplummer/boxcutter"

  gem.files = %w[
    .gitignore
    Gemfile
    Gemfile.lock
    LICENSE
    README.markdown
    Rakefile
    boxcutter.gemspec
    lib/boxcutter.rb
    lib/boxcutter/api.rb
    lib/boxcutter/command.rb
    lib/boxcutter/load_balancer.rb
    lib/boxcutter/load_balancer/application.rb
    lib/boxcutter/load_balancer/backend.rb
    lib/boxcutter/load_balancer/machine.rb
    lib/boxcutter/load_balancer/service.rb
    lib/boxcutter/server.rb
    lib/version.rb
  ]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "boxcutter"
  gem.require_paths = ["lib"]
  gem.version       = Boxcutter::VERSION

  gem.add_dependency('faraday')
  gem.add_dependency('trollop')
  gem.add_dependency('yajl-ruby')
end
