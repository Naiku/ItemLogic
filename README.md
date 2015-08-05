
This ruby gem is for accessing the ItemLogic API.


Usage:

Add to your Gemfile:
```
  gem 'itemlogic', git: 'git@github.com/Naiku/itemlogic.git'
```

In your code you can use it like so:
```ruby
  itemlogic = Itemlogic.new({'client_id' => 'my id', 'client_secret' => 'my secret'})

  # information on you and your clients
  pp itemlogic.me
  pp itemlogic.clients

  # information on your item banks
  pp itemlogic.banks

  # a shortcut to retrieve all resources for an api endpoint
  pp itemlogic.all(:bank_items, {bank_id: 32})

  # create a test with a two items
  pp itemlogic.create_client_test(client_id: 16, query: {title: 'Test 1', description: 'My first test', items: ['5573113c-fd58-44a8-ace5-0e6d0a422535', '51734e52-a240-47cb-99cc-28160a010120']})
```

For more routes see `lib/itemlogic.rb`

(C) 2015 Thomas R. Koll for Naiku Inc. <tomk@naiku.net>

