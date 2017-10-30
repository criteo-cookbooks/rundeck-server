include_recipe 'rundeck-server'

rundeck_server_key 'testkey' do
  type 'private'
  content 'mykeycontent'
  api_token 'random_token'
end
