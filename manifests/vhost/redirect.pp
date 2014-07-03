# Define: nginx::vhost::redirect.
#
# Redirect traffic to another vHost.
#
# Requires:
#   include nginx::server
#
define nginx::vhost::redirect (
  $dest,
  $port           = '80',
  $priority       = '10',
  $template       = 'nginx/vhost-redirect.conf.erb',
  $servername     = '',
  $serveraliases  = undef,
  $ssl            = false,
  $ssl_port       = '443',
  $ssl_cert       = $nginx::server::default_ssl_cert,
  $ssl_key        = $nginx::server::default_ssl_key,
  $status         = 'permanent',
  $magic          = '',
  $isdefaultvhost = false,
  $ipv6only       = false,
) {

  include nginx
  include nginx::params

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  # Allow both SSL'd and non-SSL'd vHosts by namespacing the files
  if $ssl == true {
    $appname = regsubst( $srvname , '^(\w+?)\..*?$' , '\1_ssl' )
  } else {
    $appname = regsubst( $srvname , '^(\w+?)\..*?$' , '\1' )
  }

  file { "${nginx::params::vdir}/${priority}-${name}":
    content => template($template),
    owner   => 'root',
    group   => '0',
    mode    => '0755',
    notify  => Service['nginx'],
    require => Package['nginx'],
  }
}
