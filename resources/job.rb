=begin
#<
Manage rundeck jobs through rundeck api

@action create Create and update rundeck job
@action delete Delete the job

@section Examples

    rundeck_server_job 'uname_job' do
      project 'linux_servers'
      config({
        description: 'A simple job running uname on all servers',
        sequence: {
          keepgoing: false,
          strategy: 'node-first',
          commands: [
            { exec: 'uname -a', description: 'Display uname command output' }
          ],
        },
        nodefilters: { dispatch: { threadcount: 10 } },
        filter: '.*'
      }) 
    end
#>
=end

actions :create, :delete
default_action :create

#<> @attribute name Name of the job, will be used to identify the job when interacting with rundeck.
attribute :name,      name_attribute:  true, regex: /^[-_+.a-zA-Z0-9]+$/
#<> @attribute project Project in which the job will be defined
attribute :project,   kind_of: String, required: true
#<> @attribute config Job configuration, it is a hash version of yaml output from rundeck api
attribute :config,    kind_of: Hash,   default: {}
#<> @attribute endpoint
attribute :endpoint,  kind_of: String, default: 'https://localhost'
#<> @attribute api_token Token used to interact with the api. See rundeck documentation to generate a token.
attribute :api_token, kind_of: String, required: true
