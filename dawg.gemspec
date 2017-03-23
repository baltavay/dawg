Gem::Specification.new do |s|
  s.name        = 'dawg'
  s.version     = '0.0.5'
  s.date        = '2017-03-23'
  s.summary     = "Deterministic acyclic finite state automaton"
  s.description = "Basic deterministic acyclic finite state automaton in ruby"
  s.authors     = ["Maksatbek Manurov"]
  s.email       = ["maksat.mansurov@gmail.com"]
  s.files       =  Dir['lib/*'] + Dir['lib/dawg/*'] + Dir['lib/dawg/dawg/*'] + Dir['lib/dawg/node/*']
  s.homepage    = "https://github.com/baltavay/dawg"
  s.license     = 'MIT'
end
