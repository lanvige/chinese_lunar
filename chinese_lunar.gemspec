# encoding: utf-8

require File.expand_path('../lib/chinese_lunar/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = "chinese_lunar"
  s.version       = ChineseLunar::VERSION

  s.authors       = ["Lanvige Jiang"]
  s.email         = ["lanvige@gmail.com"]
  s.description   = %q{Generate the Lunar date}
  s.summary       = %q{Generate the Lunar date}
  s.homepage      = "https://github.com/lanvige/chinese_lunar"

  s.files        = `git ls-files`.split("\n")
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = "lib"  

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "bundler", ">= 1.1.0"
  s.add_development_dependency "rspec",   "~> 2.9.0"
end