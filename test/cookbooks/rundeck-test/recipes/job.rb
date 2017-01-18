rundeck_server_job 'test-job' do
  project 'project'
  api_token 'random_token'
  config(
    description: '',
    loglevel: 'INFO',
    sequence: {
      commands: [
        exec: 'a command'
      ]
    })
end
