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
  $magic            = '',
  $serveraliases    = undef,
  $template_options = {},
  $isdefaultvhost   = false,
  $vhostroot        = '',
  $autoindex        = false,
  $webroot          = '/var/www',
  $ssl_path         = '',
  $ssl_cert_file    = '',
  $ssl_key_file     = ''
) {

  include nginx
  include nginx::server
  include nginx::params

  case $ssl_path {
    '':      { $nginx_ssl_path = $nginx::params::ssl_path }
    default: { $nginx_ssl_path = $ssl_path }
  }

  case $ssl_cert_file {
    '':      { $nginx_ssl_path = $nginx::params::ssl_cert_file }
    default: { $nginx_ssl_path = $ssl_cert_file }
  }

  case $ssl_key_file {
    '':      { $nginx_ssl_path = $nginx::params::ssl_key_file }
    default: { $nginx_ssl_path = $ssl_key_file }
  }

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
