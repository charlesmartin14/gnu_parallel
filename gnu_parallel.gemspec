# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)  # bin?  
require "gnu_parallel/version"

Gem::Specification.new do |s|
  s.name        = "gnu_parallel"
  s.version     = GnuParallel::VERSION
  s.authors     = ["Charles H. Martin, PhD"]
  s.email       = ["charlesmartin14@gmail.com"]
  s.homepage    = "https://github.com/charlesmartin14/gnu_parallel.git"
  s.summary     = %q{embeds GnuParallel streaming mode into ruby for processing very large flat files}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "gnu_parallel"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib,bin"]

  s.add_dependency "json"
  s.add_dependency "sourcify"
  s.add_dependency "fileutils"
  s.add_dependency "active_support"

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
    
end
