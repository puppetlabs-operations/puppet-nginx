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
  $port               = '80',
  $priority           = '10',
  $template           = 'nginx/vhost-default.conf.erb',
  $servername         = '',
  $ssl                = false,
  $ssl_port           = '443',
  $ssl_cert           = $nginx::server::default_ssl_cert,
  $ssl_key            = $nginx::server::default_ssl_key,
  $ssl_ca             = $nginx::server::default_ssl_ca,
  $ssl_crl_path       = $nginx::server::default_ssl_crl_path,
  $ssl_ciphers        = $nginx::server::default_ssl_ciphers,
  $ssl_protocols      = $nginx::server::default_ssl_protocols,
  $ssl_verify_client  = $nginx::server::default_ssl_verify_client,
  $magic              = '',
  $serveraliases      = undef,
  $template_options   = {},
  $isdefaultvhost     = false,
  $vhostroot          = '',
  $autoindex          = false,
  $webroot            = $nginx::server::default_webroot
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
    mode    => '0755',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

}
