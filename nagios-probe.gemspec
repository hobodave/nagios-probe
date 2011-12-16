# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "nagios-probe"
  s.version     = File.read('VERSION').strip
  s.authors     = ["David Abdemoulaie"]
  s.email       = ["dave@hobodave.com"]
  s.homepage    = "http://github.com/hobodave/nagios-probe"
  s.summary     = "A very simple tool to assist with creating custom nagios probes in Ruby"
  s.description = "Provides an easy to use API for generating custom probes and communicating probe success/failure to Nagios"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "thoughtbot-shoulda"
end
