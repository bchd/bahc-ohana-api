require 'webmock/rspec'

WebMock.disable_net_connect!(allow: [/localhost/, 'elasticsearch:9200'])
