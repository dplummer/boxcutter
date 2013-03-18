# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Donald Plummer"]
  gem.email         = ["donald@crystalcommerce.com"]
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
  ]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "boxcutter"
  gem.require_paths = ["lib"]
  gem.version       = "0.3.0"

  gem.add_dependency('faraday', '~> 0.8.1')
  gem.add_dependency('trollop', '~> 1.16.2')
  gem.add_dependency('yajl-ruby', '~> 1.1.0')

  gem.add_development_dependency('rspec', '~> 2.11.0')
  gem.add_development_dependency('guard', '~> 1.2.3')
  gem.add_development_dependency('guard-rspec', '~> 1.2.1')
  gem.add_development_dependency('vcr', '~> 2.2.4')
end
