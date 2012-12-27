define nginx::loadbalancer(
  $workers,
  $backups       = [],
  $priority      = 75,
  $template      = 'nginx/vhost-loadbalancing.conf.erb',
  $port          = 80,
  $ssl           = false,
  $ssl_port      = 443,
  $sslonly       = false,
  $max_fails     = 3,
  $fail_timeout  = 10,
  $proto         = 'http',
  $magic         = '',     # Accept arbitrary template data to append to the vhost
  $ssl_path      = '',
  $ssl_cert_file = '',
  $ssl_key_file  = ''
) {

  include nginx
  include nginx::params

  case $ssl_path {
    '':      { $nginx_ssl_path = $nginx::params::ssl_path }
    default: { $nginx_ssl_path = $ssl_path }
  }

  case $ssl_cert_file {
    '':      { $nginx_ssl_cert_file = $nginx::params::ssl_cert_file }
    default: { $nginx_ssl_cert_file = $ssl_cert_file }
  }

  case $ssl_key_file {
    '':      { $nginx_ssl_key_file = $nginx::params::ssl_key_file }
    default: { $nginx_ssl_key_file = $ssl_key_file }
  }

  # For some reason, $name is munged everywhere else into $appname. Here
  # we just blindly copy it over. Because lol.
  $appname = $name

  # Since this is the only vhost, we hack things up to be the default vhost
  # even though this isn't really meaningful.
  $isdefaultvhost = true

  if ! is_array($workers) {
    fail('$workers must be an array of upstream workers')
  }

  if ! is_array($backups) {
    fail('$backups must be an array of upstream workers')
  }

  file { "${nginx::params::vdir}/${priority}-${name}-loadbalancer":
    content => template($template),
    owner   => 'root',
    group   => '0',
    mode    => '644',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

}
