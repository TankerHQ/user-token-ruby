
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tanker/version"

Gem::Specification.new do |spec|
  spec.name          = "tanker-user-token"
  spec.version       = Tanker::VERSION
  spec.authors       = ["Tanker Team"]
  spec.email         = ["contact@tanker.io"]

  spec.summary       = %q{Tanker user token library packaged as a gem}
  spec.description   = %q{Building blocks to create your own user token server to use with the Tanker SDK}
  spec.homepage      = "https://github.com/TankerHQ/user-token-ruby"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|examples|bin)/})
  end

  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rbnacl-libsodium", "~> 1.0.16"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
