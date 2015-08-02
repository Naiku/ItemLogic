
This ruby gem is for accessing the ItemLogic API.


Usage:

Add to your Gemfile:

  gem 'itemlogic', git: 'git@github.com/tomk32/itemlogic.git'

  itemlogic = Itemlogic.new({'client_id' => 'my id', 'client_secret' => 'my secret'})

  # information on you and your clients
  pp itemlogic.me
  pp itemlogic.clients

  # information on your item banks
  pp itemlogic.banks

  # a shortcut to retrieve all resources for an api endpoint
  pp itemlogic.all(:bank_items, {bank_id: 32})

For more routes see lib/itemlogic.rb

(C) 2015 Thomas R. Koll for Naiku Inc. <tomk@naiku.net>

