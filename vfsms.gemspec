# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vfsms/version"

Gem::Specification.new do |s|
  s.name        = "vfsms"
  s.version     = Vfsms::VERSION
  s.authors     = ["Subhash Bhushan"]
  s.email       = ["subhash.bhushan@stratalabs.in"]
  s.homepage    = ""
  s.summary     = %q{Send SMS via ValueFirst Gateway}
  s.description = %q{Send SMS via ValueFirst Gateway}

  s.rubyforge_project = "vfsms"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
