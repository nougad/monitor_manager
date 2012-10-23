# -*- encoding: utf-8 -*-
require File.expand_path('../lib/monitor_manager/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Guillermo Álvarez"]
  gem.email         = ["guillermo@cientifico.net"]
  gem.description   = %q{Monitor Manager}
  gem.summary       = %q{Control the window manager from a web interface}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "monitor_manager"
  gem.require_paths = ["lib"]
  gem.version       = MonitorManager::VERSION
end
