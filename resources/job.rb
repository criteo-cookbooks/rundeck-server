actions :create, :delete
default_action :create

attribute :name,      name_attribute:  true, regex: /^[-_+.a-zA-Z0-9]+$/
attribute :project,   kind_of: String, required: true
attribute :config,    kind_of: Hash,   default: {}
attribute :endpoint,  kind_of: String, default: 'https://localhost'
attribute :api_token, kind_of: String, required: true
