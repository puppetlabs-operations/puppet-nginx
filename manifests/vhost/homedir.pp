# Define: nginx::vhost::homedir.
#
#   nginx vhost. serves ~/$username/public_html style web roots
#
# Parameters:
#
# Requires:
#   include nginx::server
#
define nginx::vhost::homedir (
  $port           = '80',
  $priority       = '20',
  $template       = 'nginx/vhost-homedir.conf.erb',
  $servername     = '',
  $serveraliases  = undef,
  $ssl            = false,
  $ssl_port       = '443',
  $ssl_path       = $nginx::server::default_ssl_path,
  $ssl_cert       = $nginx::server::default_ssl_cert,
  $ssl_key        = $nginx::server::default_ssl_key,
  $magic          = '',
  $isdefaultvhost = false,
  $homedir        = '/home',
  $pubdir         = 'public_html',
  $access_logs    = { '{name}.access.log' => '' },
  $error_logs     = { '{name}.error.log' => '' },
) {

  include nginx
  include nginx::params

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  # Need to make some variable names so the templates can use them!
  # Such as an app_server name that is unique, so when we have ssl and
  # non-ssl unicorn hosts they still work.
  if $ssl == true {
    $appname = regsubst( $srvname , '^(\w+?)\..*?$' , '\1_ssl' )
  } else {
    $appname = regsubst( $srvname , '^(\w+?)\..*?$' , '\1' )
  }

  file { "${nginx::params::vdir}/${priority}-${name}":
    content => template($template),
    owner   => 'root',
    group   => '0',
    mode    => '755',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

}
