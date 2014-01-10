# Define: nginx::loadbalancer
#
#   nginx vhost for loadbalancing
#
# Parameters:
#
# Requires:
#   include nginx::server
#
define nginx::loadbalancer(
  $workers,
  $caches       = [],
  $backups      = [],
  $priority     = 75,
  $template     = 'nginx/vhost-loadbalancing.conf.erb',
  $port         = 80,
  $ssl          = false,
  $ssl_port     = '443',
  $ssl_cert     = $nginx::server::default_ssl_cert,
  $ssl_key      = $nginx::server::default_ssl_key,
  $sslonly      = false,
  $max_fails    = 3,
  $fail_timeout = 10,
  $proto        = 'http',
  $magic        = '',  # Accept arbitrary template data to append to the vhost
  $locations    = '',
) {

  include nginx
  include nginx::server
  include nginx::params

  # For some reason, $name is munged everywhere else into $appname. Here
  # we just blindly copy it over. Because lol.
  $appname = $name

  # Adding new variables
  $upstream_name= "upstream_${hostname}",
  $caches_name  = "vcache_${hostname}",

  # Since this is the only vhost, we hack things up to be the default vhost
  # even though this isn't really meaningful.
  $isdefaultvhost = true

  if ! is_array($workers) {
    fail('$workers must be an array of upstream workers')
  }

  if ! is_array($backups) {
    fail('$backups must be an array of upstream workers')
  }

  file { "${nginx::params::vdir}/${priority}-${hostname}-loadbalancer":
    content => template($template),
    owner   => 'root',
    group   => '0',
    mode    => '0644',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
}
