#
# Generic jobs
#

# Template
job_template = {
  'group'              => 'Test',
  'loglevel'           => 'INFO',
  'description'        => '',
  'multipleExecutions' => true,
  'sequence' => {
    'keepgoing' => true,
    'strategy'  => 'node-first',
    'commands'  => [{
      'exec'        => 'uname -a',
      'description' => 'Output uname'
    }, {
      'exec'        => 'mkdir /tmp/test',
      'description' => 'Create a test directory'
    }, {
      'exec'        => 'touch /tmp/test/${option.version}',
      'description' => 'Create version file'
    }]
  },
  'nodefilters' => {
    'filter'   => 'location: ${option.location}',
    'dispatch' => {
      'threadcount'       => 30,
      'keepgoing'         => true,
      'excludePrecedence' => true,
      'rankOrder'         => 'ascending'
    }
  },
  'timeout' => '1h',
  'options' =>  {
    'location' => {
      'required' => true
    },
    'version' => {
      'required' => true
    },
    'environment' => {
      'required' => true
    }
  }
}

# Release using one thread
default['rundeck_test']['jobs']['Test']['Release (single)'] = job_template.dup
default['rundeck_test']['jobs']['Test']['Release (single)']['nodefilters']['dispatch']['threadcount'] = 1

# Release using six threads
default['rundeck_test']['jobs']['Test']['Release (parallel)'] = job_template.dup
default['rundeck_test']['jobs']['Test']['Release (parallel)']['nodefilters']['dispatch']['threadcount'] = 6

#
# Wrapper jobs
#

# Template
release_wrapper_template = {
  'description' =>
"Release the service across datacenters.\n
Total maximum number of threads set to 100.\n",
  'loglevel' => 'INFO',
  'sequence' => {
    'keepgoing' => true,
    'strategy'  => 'parallel',
    'commands'  => [] # This is filled automatically by the loops below
  },
  'nodefilters' => {
    'filter'   => 'tags: service',
    'dispatch' => {
      'threadcount'       => 90,
      'keepgoing'         => true,
      'excludePrecedence' => true,
      'rankOrder'         => 'ascending'
    }
  },
  'options' => {
    'version' => {
      'required'    => true,
      'description' => 'The version to release (upgrade or downgrade).'
    }
  }
}

# Host release wrapper jobs
environments = %w(prod preprod)        # One wrapper job per environment
locations    = %w(Europe America Asia) # All locations

environments.each do |environment|
  # Create the wrapper job from the template
  default['rundeck_test']['jobs']['Test']["Release (#{environment})"] = release_wrapper_template.dup
  # Wrap different jobs depending on location
  locations.each do |location|
    if location.match('A')
      step = {
        'jobref' => {
          'group' => 'Test',
          'name'  => 'Release (parallel)',
          'args'  =>  "-location #{location} -version ${option.version} -environment #{environment}"
        },
        'description' => "Parallel rollout in #{location}"
      }
    else
      step = {
        'jobref' => {
          'group' => 'Test',
          'name'  => 'Release (single)',
          'args'  =>  "-location #{location} -version ${option.version} -environment #{environment}"
        },
        'description' => "Single rollout in #{location}"
      }
    end
    default['rundeck_test']['jobs']['Test']["Release (#{environment})"]['sequence']['commands'].push(step)
  end
end
