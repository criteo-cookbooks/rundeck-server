=begin
#<
project provider configures a rundeck project

@action create  Create a rundeck project.
@action delete  Delete a rundeck project.

@section Examples

     # winrm example
     rundeck_server_project 'windows_servers' do
       executor({
         provider: 'overthere-winrm',
         config: {
          'winrm-auth-type'      => 'certificate',
          'winrm-protocol'       => 'https',
          'winrm-cert-trust'     => 'all',
          'winrm-hostname-trust' => 'all',
          'winrm-cert'           =>  [PKCS#12 key for Java]
         }
       })
       sources([{
        'type'            => 'url',
        'config.url'      => "http://url,
        'config.timeout'  => 30,
        'config.cache'    => true
      }])
     end

     # ssh example
     rundeck_server_project 'linux_servers' do
       executor 'ssh'
       sources([{
        'type'            => 'url',
        'config.url'      => "http://chef-bridge/linux,
        'config.timeout'  => 30,
        'config.cache'    => true
      }])
     end
#>
=end

actions :create, :delete
default_action :create

# <> @attribute name Name of the project
attribute :name,
          kind_of: String,
          name_attribute: true,
          regex: /^[-_+.a-zA-Z0-9]+$/

# <> @attribute executor Executor name + configuration. Could be a plain string (ssh) or complex hash configuration.
attribute :executor,
          kind_of: [Symbol, Hash],
          default: :ssh,
          callbacks: {
            must_contain_provider: lambda do |executor|
              executor.is_a?(Symbol) || !executor['provider'].nil? || !executor[:provider].nil?
            end,
            must_contain_config: lambda do |executor|
              executor.is_a?(Symbol) || (executor['config'] || executor[:config]).is_a?(Hash)
            end
          }

# <> @attribute sources List of node sources
attribute :sources,
          kind_of: Array,
          required: true,
          callbacks: {
            must_be_an_array_of_hashes: lambda do |sources|
              sources.all? { |source| source.is_a?(Hash) }
            end,
            must_contain_type: lambda do |sources|
              sources.all? { |source| source['type'] || source[:type] }
            end
          }

attribute :cookbook,
          kind_of: String,
          default: 'rundeck-server'
