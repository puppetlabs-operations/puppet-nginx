# Define: nginx::server::vhost
#
#   Deploy an nginx vhost configuration file.
#
# Parameters:
#
# Requires:
#   include nginx::server
#
define nginx::vhost(
  $port             = '80',
  $priority         = '10',
  $template         = 'nginx/vhost-default.conf.erb',
  $servername       = '',
  $ssl              = false,
  $ssl_port         = '443',
  $ssl_path         = $nginx::server::default_ssl_path,
  $ssl_cert         = $nginx::server::default_ssl_cert,
  $ssl_key          = $nginx::server::default_ssl_key,
  $magic            = '',
  $serveraliases    = undef,
  $template_options = {},
  $isdefaultvhost   = false,
  $vhostroot        = '',
  $autoindex        = false,
  $webroot          = $nginx::server::default_webroot,
  $access_logs      = { '{name}.access.log' => '' },
  $error_logs       = { '{name}.error.log' => '' },
) {

  include nginx
  include nginx::server
  include nginx::params

  # Determine the name of the vhost
  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  # Determine the location to put the root of this vhost
  if $vhostroot == '' {
    $docroot = "${webroot}/${srvname}"
  } else {
    $docroot = $vhostroot
  }

  # Write the nginx configuration
  file { "${nginx::params::vdir}/${priority}-${name}":
    content => template($template),
    owner   => 'root',
    group   => '0',
    mode    => '755',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

}
