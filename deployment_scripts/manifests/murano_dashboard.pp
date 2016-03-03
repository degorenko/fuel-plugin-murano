notice('MURANO PLUGIN: murano_dashboard.pp')

$murano_hash    = hiera('murano_hash', {})
$murano_plugins = $murano_hash['plugins']

$repository_url = has_key($murano_hash, 'murano_repo_url') ? {
  true    => $murano_hash['murano_repo_url'],
  default => 'http://storage.apps.openstack.org',
}

class { 'murano::dashboard':
  repo_url => $repository_url,
  sync_db  => false,
}

if has_key($murano_plugins, 'glance_artifacts_plugin') and $murano_plugins['glance_artifacts_plugin']['enabled'] {
  include ::murano::params

  concat::fragment { 'enable_glare':
    target  => $::murano::params::local_settings_path,
    content => 'MURANO_USE_GLARE = True',
    order   => 3,
  }
}

include ::murano::client
