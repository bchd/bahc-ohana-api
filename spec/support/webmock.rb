require 'webmock/rspec'

WebMock.disable_net_connect!(allow: [/localhost/, '/127.0.0.1/', 'elasticsearch:9200'])
