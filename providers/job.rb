use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  @current_resource = Chef::Resource::RundeckServerJob.new(@new_resource.name)
  @current_resource.project(@new_resource.project)
end

def stringify(h)
  case h
  when Hash
    h.inject({}) do |memo, (k, v)|
      memo[k.to_s] = stringify v
      memo
    end
  when Array
    h.map { |el| stringify el }
  else
    h
  end
end

action :create do
  require 'rundeck'
  require 'yaml'

  client = Rundeck.client(endpoint: @new_resource.endpoint, api_token: @new_resource.api_token)

  job = find_job client, @current_resource.project, @current_resource.name

  updated_job = stringify @new_resource.config.dup

  # hydrate updated_job
  updated_job['name']    ||= @current_resource.name
  updated_job['project'] ||= @current_resource.project
  updated_job['uuid']    ||= job['uuid'] if job

  tweak_existing job if job

  action_name = 'create'
  action_name = 'update' if job

  if job.nil? || !equal(job, updated_job)
    Chef::Log.debug('before: ' + job.inspect)
    Chef::Log.debug('after: ' + updated_job.inspect)

    # yamlize update_job
    job_yaml = [updated_job].to_yaml.gsub(/^---\n/, '')

    converge_by "#{action_name} job #{@current_resource.project}/#{@current_resource.name}" do
      response = client.import_jobs(job_yaml, 'yaml', opts)
      Chef::Log.debug('Result: ' + response.inspect)
      fail "Error while updating job! Response: #{response.inspect}" if response.to_h['failed']['count'].to_i > 0
    end
  end
end

action :delete do
  require 'rundeck'

  client = Rundeck.client(endpoint: @new_resource.endpoint, api_token: @new_resource.api_token)

  job = find_job(client, current_resource.project, @current_resource.name)
  if job
    converge_by "delete job #{@current_resource.project}/#{@current_resource.name}" do
      client.delete_job(job['id'], opts)
    end
  else
    Chef::Log.debug 'Nothing to do, job does not exist'
  end
end

private

# return job config as a hash
def find_job(client, project, name)
  id = find_job_id(client, project, name)
  client.job(id, opts).to_hash if id
end

# default options for rundeck api
# dupeOption allow us to update jobs (default is create, which fails)
def opts
  { verify: false, query: { dupeOption: 'update' } }
end

# hash equality with clearer diff
def equal(h1, h2)
  (h1.keys + h2.keys).uniq.all? do |k|
    if h1[k] != h2[k]
      Chef::Log.debug("key: #{k}, before: #{h1[k].inspect}, after: #{h2[k].inspect}")
    end
    h1[k] == h2[k]
  end
end

def find_job_id(client, project, name)
  jobs = client.jobs(project, opts).to_h['job']
  job = case jobs
        when NilClass # no job
          nil
        when Array # multiple jobs
          matching_jobs = jobs.select { |j| j['name'] == name }
          fail "Several jobs exist with name #{name}, unable to choose" unless matching_jobs.size < 2
          matching_jobs.first
        when Hash # one job
          jobs
        end
  job['id'] if job
end

def tweak_existing(job)
  # we need to specify uuid, not id to be able to update
  job.delete('id')

  # rundeck gem returns project in context instead of directly project
  # which is required to create job
  context = job.delete('context')
  job['project'] = context['project'] if context

  if job['sequence']
    # rundeck gem does not type boolean properly
    job['sequence']['keepgoing'] = job['sequence']['keepgoing'] == 'true' unless job['sequence']['keepgoing'].nil?
    # when single command, we need this
    job['sequence']['commands'] ||= [job['sequence'].delete('command')]
  end

  job
end
