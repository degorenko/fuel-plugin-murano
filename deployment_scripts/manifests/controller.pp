notice('updating controller node')

$detach_murano_plugin = hiera('detach-murano', undef)
$murano_cfapi = $detach_murano_plugin['murano_cfapi']
$murano_glance_artifacts = $detach_murano_plugin['murano_glance_artifacts']
$murano_repo_url = $detach_murano_plugin['murano_repo_url']

file_line { 'murano_repo_url':
  line => "export MURANO_REPO_URL=\'${murano_repo_url}\'",
  path => '/root/openrc',
}

if $murano_glance_artifacts {
  file_line { 'murano_glare_plugin':
    line => "export MURANO_PACKAGES_SERVICE='glance'",
    path => '/root/openrc',
  }

  package {'murano-glance-artifacts-plugin':
    ensure  => installed,
  }

  glance_api_config {
    'DEFAULT/enable_v3_api': value => true,
  }
}
