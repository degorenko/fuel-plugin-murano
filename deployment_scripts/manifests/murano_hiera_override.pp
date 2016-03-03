notice('MURANO PLUGIN: murano_hiera_override.pp')

$detach_murano_plugin = hiera('detach-murano', undef)
$hiera_dir = '/etc/hiera/plugins'
$plugin_name = 'detach-murano'
$plugin_yaml = "${plugin_name}.yaml"

if $detach_murano_plugin {
  $network_metadata           = hiera_hash('network_metadata')
  $murano_nodes               = get_nodes_hash_by_roles($network_metadata, ['primary-murano-node', 'murano-node'])
  $murano_address_map         = get_node_to_ipaddr_map_by_network_role($murano_nodes, 'management')
  $murano_nodes_ips           = values($murano_address_map)
  $murano_nodes_names         = keys($murano_address_map)
  $murano_cfapi_enabled       = $detach_murano_plugin['murano_cfapi']
  $murano_repo_url            = $detach_murano_plugin['murano_repo_url']
  $murano_glance_artifacts    = $detach_murano_plugin['murano_glance_artifacts']
  $syslog_log_facility_murano = hiera('syslog_log_facility_murano', 'LOG_LOCAL0')
  $default_log_levels         = hiera('default_log_levels')

  # hardcode for now
  $murano_db_password         = 'change_me'
  $murano_rabbit_password     = 'change_me'
  $murano_user_password       = 'change_me'

  ###################
  $calculated_content = inline_template('
murano_hash:
  murano_ipaddresses:
<%
@murano_nodes_ips.each do |muranoip|
%>    - <%= muranoip %>
<% end -%>
  murano_nodes:
<%
@murano_nodes_names.each do |muranoname|
%>    - <%= muranoname %>
<% end -%>
  rabbit:
    vhost: "/"
    port: "55572"
  db_password: <%= @murano_db_password %>
  rabbit_password: <%= @murano_rabbit_password %>
  user_password: <%= @murano_user_password %>
  murano_repo_url: <%= @murano_repo_url %>
  plugins:
    glance_artifacts_plugin:
      enabled: <%= @murano_glance_artifacts %>
murano_cfapi_hash:
  enabled: <%= @murano_cfapi_enabled %>
syslog_log_facility_murano: <%= @syslog_log_facility_murano %>
"murano::logging::default_log_levels":
<%
@default_log_levels.each do |k,v|
%>  <%= k %>: <%= v %>
<% end -%>
')

  ###################
  file {'/etc/hiera/override':
    ensure  => directory,
  } ->
  file { "${hiera_dir}/${plugin_yaml}":
    ensure  => file,
    content => "${calculated_content}",
  }

  package {'ruby-deep-merge':
    ensure  => 'installed',
  }
}
