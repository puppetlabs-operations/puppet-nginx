define nginx::loadbalancer(
  $workers,
  $priority       = 75,
  $template       = 'nginx/vhost-loadbalancing.conf.erb',
  $port           = 80,
  $ssl            = false,
  $ssl_port       = 443,
  $sslonly        = false,
  $max_fails      = 1,
  $fail_timeout   = 10,
) {

  include nginx
  include ssl::params
  $ssl_path = $ssl::params::ssl_path

  # For some reason, $name is munged everywhere else into $appname. Here
  # we just blindly copy it over. Because lol.

  $appname = $name

  if ! is_array($workers) {
    fail('$workers must be an array of upstream workers')
  }

  file { "${nginx::params::vdir}/${priority}-${name}_lb":
    content => template($template),
    owner   => 'root',
    group   => '0',
    mode    => '644',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
}
