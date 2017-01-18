use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::RundeckServerJob.new(@new_resource.name)
  @current_resource.project(@new_resource.project)
end

action :create do
  require 'rundeck'
  require 'yaml'

  client = Rundeck.client(endpoint: @new_resource.endpoint, api_token: @new_resource.api_token)
  job = get_job(client, @current_resource.project, @current_resource.name)

  updated_job = stringify(@new_resource.config.dup)

  # hydrate updated_job
  updated_job['name']    ||= @current_resource.name
  updated_job['project'] ||= @current_resource.project
  updated_job['uuid']    ||= job['uuid'] if job

  # we need to specify uuid, not id to be able to update
  job.delete('id') if job

  action_name = 'create'
  action_name = 'update' if job

  if job.nil? || !equal_with_diff(job, updated_job)
    Chef::Log.debug('before: ' + job.inspect)
    Chef::Log.debug('after: ' + updated_job.inspect)

    # yamlize update_job
    job_yaml = [updated_job].to_yaml.gsub(/^---\n/, '')

    # encode % in job config
    job_yaml = job_yaml.gsub(/\%/, '%25')
    # encode + in job config
    job_yaml = job_yaml.gsub(/\+/, '%2B')
    # encode & in job config
    job_yaml = job_yaml.gsub(/&/, '%26')

    converge_by "#{action_name} job #{@current_resource.project}/#{@current_resource.name}" do
      # dupeOption allow us to update jobs (default is create, which fails)
      response = client.import_jobs(job_yaml, 'yaml', opts.merge(query: { 'dupeOption' => 'update' }))
      Chef::Log.debug('Result: ' + response.inspect)
      fail "Error while updating job! Response: #{response.inspect}" if response.to_h['failed']['count'].to_i > 0
    end
  end
end

action :delete do
  require 'rundeck'

  client = Rundeck.client(endpoint: @new_resource.endpoint, api_token: @new_resource.api_token)
  job = get_job(client, @current_resource.project, @current_resource.name)

  if job
    converge_by "delete job #{@current_resource.project}/#{@current_resource.name}" do
      client.delete_job(job['id'], opts)
    end
  else
    Chef::Log.debug 'Nothing to do, job does not exist'
  end
end

private

# Default options for RunDeck API
def opts
  # Sent through to HTTParty to disable SSL verification
  options = { verify: false }
  # Return options
  options
end

# Get a job hash by project and name
def get_job(client, project, name)
  require 'yaml'
  # export the job in YAML
  job = client.export_jobs(project, 'yaml', opts.merge(query: { 'jobFilter' => name }))
  # return the parsed YAML
  YAML.load(job).first
end

# Hash equality with a clearer diff
def equal_with_diff(h1, h2)
  if h1.class != h2.class
    Chef::Log.info('Not the same class!')
    Chef::Log.info("before: #{h1.class}")
    Chef::Log.info("after:  #{h2.class}")
    return false
  end
  case h1
  when Hash
    (h1.keys + h2.keys).uniq.all? do |k|
      if h1[k] != h2[k]
        Chef::Log.info("Difference for key: #{k}")
        equal_with_diff(h1[k], h2[k])
      end
      h1[k] == h2[k]
    end
  when Array
    Chef::Log.info('Not the same size!') if h1.size != h2.size
    h1.zip(h2).all? do |el|
      if el[0] != el[1]
        Chef::Log.info('Difference for array element')
        equal_with_diff(el[0], el[1])
        Chef::Log.info('array before: ' + h1.to_s)
        Chef::Log.info('array after: ' + h2.to_s)
      end
      el[0] == el[1]
    end
  else
    if h1 != h2
      Chef::Log.info('before: ' + h1.to_s)
      Chef::Log.info('after: ' + h2.to_s)
    end
    h1 == h2
  end
end

# Stringify the Chef attributes hash
def stringify(h)
  case h
  when Hash
    h.each_with_object({}) do |(k, v), memo|
      memo[k.to_s] = stringify v
    end
  when Array
    h.map { |el| stringify el }
  else
    h
  end
end
