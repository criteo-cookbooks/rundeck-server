actions :create, :delete
default_action :create

attribute :name,      kind_of: String,
  name_attribute: true,
  regex: /^[-_+.a-zA-Z0-9]+$/
attribute :executor,  kind_of: [Symbol, Hash],  default: :ssh,
  callbacks: {
    must_contain_provider: lambda { |executor|
      executor.is_a?(Symbol) || !!executor['provider'] || !!executor[:provider]
    },
    must_contain_config: lambda { |executor|
      executor.is_a?(Symbol) || (executor['config'] || executor[:config]).is_a?(Hash)
    },
  }
attribute :sources,   kind_of: Array,
  required: true,
  callbacks: {
    must_be_an_array_of_hashes: lambda { |sources|
      sources.all? {|source| source.is_a?(Hash)}
    },
    must_contain_type: lambda { |sources|
      sources.all? {|source| source['type'] || source[:type]}
    },
  }
attribute :cookbook,  kind_of: String,          default: 'rundeck-server'
