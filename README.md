# Description

Installs rundeck and configure as needed

# Requirements

## Platform:

* Chef >= 12.1.0
* Centos

## Cookbooks:

* yum
* java
* rundeck-bridge (Suggested but not required)
* rundeck-node (Suggested but not required)

# Attributes

Name | Description | Default
-----|-------------|--------
* `node['rundeck_server']['install_java']` |Installs Java |Defaults to `true`.
* `node['rundeck_server']['packages']`|A hash of package name and version to install |Defaults to `2.5.3-1.10.GA`.
* `node['rundeck_server']['confdir']` |  |Defaults to `"/etc/rundeck"`.
* `node['rundeck_server']['basedir']` |  |Defaults to `"/var/lib/rundeck"`.
* `node['rundeck_server']['logdir']`  |  |Defaults to `"/var/log/rundeck"`.
* `node['rundeck_server']['datadir']` |  |Defaults to `"/var/rundeck"`.
* `node['rundeck_server']['rolename']` | Default security-role/role-name allowed to authenticate. |Defaults to `"user"`.
* `node['rundeck_server']['session_timeout']` | session timeout in the UI (in minutes). |Defaults to `"30"`.
* `node['rundeck_server']['repo']` | Repository containing the rundeck package. |Defaults to `"http://dl.bintray.com/rundeck/rundeck-rpm/"`.
* `node['rundeck_server']['plugins']['winrm']['url']` | Plugin list to install. Type is { 'pluginname' => { 'url' => URL } }. |Defaults to `"https://github.com/rundeck-plugins/rundeck-winrm-plugin/releases/download/v1.2/rundeck-winrm-plugin-1.2.jar"`.
* `node['rundeck_server']['jvm']['Dloginmodule.name']` |  |Defaults to `"RDpropertyfilelogin"`.
* `node['rundeck_server']['jvm']['Drdeck.config']` |  |Defaults to `"node['rundeck_server']['confdir']"`.
* `node['rundeck_server']['jvm']['Drundeck.server.configDir']` |  |Defaults to `"node['rundeck_server']['confdir']"`.
* `node['rundeck_server']['jvm']['Drundeck.server.serverDir']` |  |Defaults to `"node['rundeck_server']['basedir']"`.
* `node['rundeck_server']['jvm']['Drdeck.base']` |  |Defaults to `"node['rundeck_server']['basedir']"`.
* `node['rundeck_server']['jvm']['Dserver.http.host']` | Address/hostname to listen on. |Defaults to `"0.0.0.0"`.
* `node['rundeck_server']['jvm']['Dserver.http.port']` | The HTTP port to use for the server. |Defaults to `"4440"`.
* `node['rundeck_server']['jvm']['Dserver.https.port']` | The HTTPS port to use or the server. |Defaults to `"4443"`.
* `node['rundeck_server']['jvm']['Djava.io.tmpdir']` |  |Defaults to `"::File.join('tmp', 'rundeck')"`.
* `node['rundeck_server']['jvm']['Dserver.datastore.path']` | Path to server datastore dir. |Defaults to `"::File.join(node['rundeck_server']['basedir'], 'data')"`.
* `node['rundeck_server']['jvm']['Djava.security.auth.login.config']` |  |Defaults to `"::File.join(node['rundeck_server']['confdir'], 'jaas-loginmodule.conf')"`.
* `node['rundeck_server']['jvm']['Drdeck.projects']` |  |Defaults to `"::File.join(node['rundeck_server']['datadir'], 'projects')"`.
* `node['rundeck_server']['jvm']['Drdeck.runlogs']` |  |Defaults to `"::File.join(node['rundeck_server']['basedir'], 'logs')"`.
* `node['rundeck_server']['jvm']['Drundeck.config.location']` |  |Defaults to `"::File.join(node['rundeck_server']['confdir'], 'rundeck-config.properties')"`.
* `node['rundeck_server']['jvm']['XX:MaxPermSize']` |  |Defaults to `"256m"`.
* `node['rundeck_server']['jvm']['Xmx1024m']` |  |Defaults to `"true"`.
* `node['rundeck_server']['jvm']['Xms256m']` |  |Defaults to `"true"`.
* `node['rundeck_server']['jvm']['server']` |  |Defaults to `"true"`.
* `node['rundeck_server']['threadcount']` | Quartz job threadCount. |Defaults to `"10"`.
* `node['rundeck_server']['rundeck-config.properties']['loglevel.default']` |  |Defaults to `"INFO"`.
* `node['rundeck_server']['rundeck-config.properties']['dataSource.url']` | Default database URL |Defaults to `jdbc:h2:file:~/grailsh2`.
* `node['rundeck_server']['rundeck-config.properties']['rdeck.base']` |  |Defaults to `"node['rundeck_server']['basedir']"`.
* `node['rundeck_server']['rundeck-config.properties']['rss.enabled']` |  |Defaults to `"false"`.
* `node['rundeck_server']['rundeck-config.properties']['grails.serverURL']` |  |Defaults to `"http://localhost:4440"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.server.name']` |  |Defaults to `"localhost"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.server.hostname']` |  |Defaults to `"localhost"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.server.port']` |  |Defaults to `"4440"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.server.url']` |  |Defaults to `"http://localhost:4440"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.server.username']` |  |Defaults to `"admin"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.server.password']` | This should be replaced by values in the optional encrypted data bag |Defaults to `"admin"`.
* `node['rundeck_server']['rundeck-config.framework']['rdeck.base']` |  |Defaults to `"/var/lib/rundeck"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.projects.dir']` |  |Defaults to `"/var/rundeck/projects"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.etc.dir']` |  |Defaults to `"/etc/rundeck"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.var.dir']` |  |Defaults to `"/var/lib/rundeck/var"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.tmp.dir']` |  |Defaults to `"/var/lib/rundeck/var/tmp"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.logs.dir']` |  |Defaults to `"/var/lib/rundeck/logs"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.libext.dir']` |  |Defaults to `"/var/lib/rundeck/libext"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.ssh.keypath']` |  |Defaults to `"/var/lib/rundeck/.ssh/id_rsa"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.ssh.user']` |  |Defaults to `"rundeck"`.
* `node['rundeck_server']['rundeck-config.framework']['framework.ssh.timeout']` |  |Defaults to `"0"`.
* `node['rundeck_server']['realm.properties']['admin']` | Admin User Password, Roles. This should probably come from the optional encrypted databag. See example for details. |Defaults to `"admin,user,admin,architect,deploy,build"`.
* `node['rundeck_server']['jaas']` | The JAAS login configuration file with one entry and multiple modules may be generated from this attribute. |Defaults to `"[ ... ]"`.
* `node['rundeck_server']['aclpolicy']['admin']` | The admin ACL policy in YAML is generated from this attribute. |Defaults to `"[ ... ]"`.
* `node['rundeck_server']['yum']['description']` |Rundeck yum resource parameter |Defaults to `"Rundeck Official Repo"`
* `node['rundeck_server']['yum']['gpgcheck']` |Rundeck yum resource parameter |Defaults to `true`
* `node['rundeck_server']['yum']['enabled']` |Rundeck yum resource parameter |Defaults to `true`
* `node['rundeck_server']['yum']['baseurl']` |Rundeck yum resource parameter |Defaults to `"http://dl.bintray.com/rundeck/rundeck-rpm/"`
* `node['rundeck_server']['yum']['gpgkey']` |Rundeck yum resource parameter |Defaults to `"http://rundeck.org/keys/BUILD-GPG-KEY-Rundeck.org.key"`
* `node['rundeck_server']['yum']['action']` |Rundeck yum resource parameter |Defaults to `:create`
* `node['rundeck_server']['cli']['config']` |Parameters to configure Rundeck CLI for Rundeck 2.7.x . See [documentation](https://github.com/rundeck/rundeck-cli/blob/master/docs/configuration.md)|Defaults to `{ RD_URL: 'http://localhost:4440' }`
* `node['rundeck_server']['cli']['version']` |Allows to dictate version of Rundeck CLI to install|Defaults to 1.0.4-1
* `node['rundeck_server']['databag']['name']` |(Optional) Store sensitive configuration data|Defaults to `rundeck_server`
* `node['rundeck_server']['databag']['item']` |(Optional) The single item in the encrypted data bag|Defaults to `secrets`

# Data Bags

Optinally, an encrypted data bag may be used. The data bag provides sensitive
information that you may not want to store in regular node attributes. The data
bag name should match the `node['rundeck_server']['databag']['name']` attribute.
The single item that rests inside the data bag should have a name that matches the
`node['rundeck_server']['databag']['item']` attribute,

Currently, the items that may be stored in the encrypted data bag are:

* rundeck-config.framework
* rundeck-config.properties
* jaas
* realm.properties

If included, the content of these items will update the attributes of the same
name in the node `rundeck_server` attribute hash. If an value for any of these attributes
duplicates values found in the original node attribute, the node attribute values
will be replaced when applied to the configuration recipe. The actual attributes at
the node level will not be changed.

```
{
	"id" : "secrets",
	"rundeck-config.framework" : {
		"framework.server.username" : "admin",
		"framework.server.password" : "admin"
	},
	"jaas" : [],
	"rundeck-config.properties" : {},
  "realm.properties" : {
		"admin" : "MD5:21232f297a57a5a743894a0e4a801fc3,user,admin,architect,deploy,build"
	}
}
```

Note that these values will override the default node attributes during converge.
Also note that the admin password above is "admin" hashed to MD5.

# Recipes

* rundeck-server::install
* rundeck-server::config
* rundeck-server::install_cli - Installs the [Rundeck CLI](https://rundeck.github.io/rundeck-cli/) - Only use for Rundeck 2.7.x and above
* [rundeck-server::default](#rundeck-serverdefault)

## rundeck-server::default

This recipe call config recipe and setup rundeck-server service
It also install rundeck gem to allow to configure rundeck via ruby

# Resources

* [rundeck-server_job](#rundeck-server_job)
* [rundeck-server_project](#rundeck-server_project)

## rundeck-server_job

Manage rundeck jobs through rundeck api

### Actions

- create: Create and update rundeck job Default action.
- delete: Delete the job

### Attribute Parameters

- name: Name of the job, will be used to identify the job when interacting with rundeck.
- project: Project in which the job will be defined
- config: Job configuration, it is a hash version of yaml output from rundeck api Defaults to <code>{}</code>.
- endpoint:  Defaults to <code>"https://localhost"</code>.
- api_token: Token used to interact with the api. See rundeck documentation to generate a token.

### Examples

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

## rundeck-server_project

project provider configures a rundeck project

### Actions

- create: Create a rundeck project. Default action.
- delete: Delete a rundeck project.

### Attribute Parameters

- name: Name of the project
- executor: Executor name + configuration. Could be a plain string (ssh) or complex hash configuration. Defaults to <code>:ssh</code>.
- sources: List of node sources
- cookbook:  Defaults to <code>"rundeck-server"</code>.

### Examples

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
        'config.cache'    => true,
      }])
     end

     # ssh example
     rundeck_server_project 'linux_servers' do
       executor 'ssh'
       sources([{
        'type'            => 'url',
        'config.url'      => "http://chef-bridge/linux,
        'config.timeout'  => 30,
        'config.cache'    => true,
      }])
     end

Mysql conf example
------------------

If you need to connect rundeck to a mysql example, you simply have to put:

- default['rundeck_server']['rundeck-config.properties']['dataSource.url']      = 'jdbc:mysql://localhost/rundeckdb?autoReconnect=true'
- default['rundeck_server']['rundeck-config.properties']['dataSource.username'] = 'rundeck'
- default['rundeck_server']['rundeck-config.properties']['dataSource.password'] = 'secret'

See rundeck doc for more information.


# License and Maintainer

Maintainer:: Robert Veznaver (<r.veznaver@criteo.com>)

License:: Apache License 2.0
