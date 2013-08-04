Gem::Specification.new do |s|
  s.name        = 'qgame'
  s.authors     = ['Ryan Scott']
  s.email       = 'atthealma@gmail.com'
  s.homepage    = 'https://github.com/Archytaus/qgame'
  s.license     = 'MIT'

  s.version     = '0.1.0'
  s.date        = '2013-08-05'

  s.summary     = 'QGame'
  s.description = /QGame is designed to allow quick game prototyping across multiple
                   platforms leveraging the mruby runtime./

  s.executables << 'qgame'

  s.files       =  Dir['lib/**/*']
  s.files       += Dir['include/**/*']
  s.files       += Dir['mrbgems/**/*']
  s.files       += Dir['src/**/*']
  s.files       += Dir['tasks/**/*']
  s.files       += Dir['tools/**/*']
  s.files       += ['bin/qgame']
end