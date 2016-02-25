notice('MURANO PLUGIN: murano_dashboard.pp')

$murano_hash = hiera('murano_hash', {})

$repository_url = has_key($murano_hash, 'murano_repo_url') ? {
  true    => $murano_hash['murano_repo_url'],
  default => 'http://storage.apps.openstack.org',
}

class { 'murano::dashboard':
  repo_url => $repository_url,
  sync_db  => false,
}

include ::murano::client
