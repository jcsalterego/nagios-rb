$LOAD_PATH.unshift 'lib'
require 'nagios/version'

Gem::Specification.new do |s|
  s.name              = "nagios"
  s.version           = Nagios::Version
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "nagios-rb is a compact framework for writing Nagios plugins."
  s.homepage          = "http://github.com/jcsalterego/nagios-rb"
  s.email             = "jerry@apache.org"
  s.authors           = [ "Jerry Chen" ]
  
  s.files             = %w( README.md )
  s.files            += Dir.glob("lib/**/*")
  s.executables       = [ ]

  s.extra_rdoc_files  = [ "LICENSE", "README.md" ]

  s.description = <<-description
    Nagios-rb is a compact framework for writing Nagios plugins.
  description
end
