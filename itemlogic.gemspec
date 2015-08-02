Gem::Specification.new do |s|
  s.name        = 'itemlogic'
  s.version     = '0.1.0'
  s.date        = '2015-08-01'
  s.summary     = "ItemLogic API"
  s.description = "Ruby gem for the ItemLogic API"
  s.authors     = ["Thomas R. Koll"]
  s.email       = 'tomk@naiku.net'
  s.files       = [
    "lib/itemlogic.rb",
    "lib/itemlogic/client.rb"
  ]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.homepage    = 'https://github.com/Naiku/itemlogic'
  s.license     = 'MIT'
  s.add_dependency 'httparty'
  s.add_dependency 'multi_json'
end
