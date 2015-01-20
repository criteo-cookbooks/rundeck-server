require 'chefspec'
require 'chefspec/berkshelf'

require 'rundeck'

RSpec.configure do |config|
  config.platform = 'centos'
  config.version  = '6.5'
end

def mock_web_xml(role_name = 'user')
  before(:each) do
    allow(::File).to receive(:new).with(
      '/var/lib/rundeck/exp/webapp/WEB-INF/web.xml'
    ).and_return(<<XML)
<web-app>
  <security-role>
    <role-name>#{role_name}</role-name>
  </security-role>
</web-app>
XML
  end
end
