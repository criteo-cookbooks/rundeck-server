actions :create, :delete
default_action :create

attribute :name,
          kind_of: String,
          name_attribute: true,
          regex: /^[-_+.a-zA-Z0-9]+$/

attribute :executor,
          kind_of: [Symbol, Hash],
          default: :ssh,
          callbacks: {
            must_contain_provider: lambda do |executor|
              executor.is_a?(Symbol) || !executor['provider'].nil? || !executor[:provider].nil?
            end,
            must_contain_config: lambda do |executor|
              executor.is_a?(Symbol) || (executor['config'] || executor[:config]).is_a?(Hash)
            end,
          }

attribute :sources,
          kind_of: Array,
          required: true,
          callbacks: {
            must_be_an_array_of_hashes: lambda do |sources|
              sources.all? { |source| source.is_a?(Hash) }
            end,
            must_contain_type: lambda do |sources|
              sources.all? { |source| source['type'] || source[:type] }
            end,
          }

attribute :cookbook,
          kind_of: String,
          default: 'rundeck-server'
