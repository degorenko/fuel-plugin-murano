notice('MURANO PLUGIN: update_openrc.pp')

$murano_hash     = hiera_hash('murano_hash', {})
$murano_plugins  = $murano_hash['plugins']
$murano_repo_url = $murano_hash['murano_repo_url']

file_line { 'murano_repo_url':
  line  => "export MURANO_REPO_URL=\'${murano_repo_url}\'",
  match => '^export\ MURANO_REPO_URL\=',
  path  => '/root/openrc',
}

if $murano_plugins['glance_artifacts_plugin']['enabled'] {
  file_line { 'murano_glare_plugin':
    line => "export MURANO_PACKAGES_SERVICE='glance'",
    match => '^export\ MURANO_PACKAGES_SERVICE\=',
    path => '/root/openrc',
  }
}
