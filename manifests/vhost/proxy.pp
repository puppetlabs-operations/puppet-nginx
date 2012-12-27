# Parameterised Class: nginx::vhost::proxy
#
#   Nginx standard cache for offloading connections. Saves the
#   backend app server having to do it.
#
#   foreverything beyond it. Is probably therefore not compaitable
#   with other nginx modules.
#
# Parameters:
#   upstream_server/port are the apache/unicorn thing behind the
#   scenes.
#
#   port is the port to listen on, on all interfaces, so don't use 80
#   unless you want it to be the prime site.
#
#   magic is just if you want to include a chunk of other options as a
#   text blob.
#
# Actions:
#
# Requires:
#
# include nginx::server
#
# Sample Usage:
#
#  class { 'nginx::cache': port => 80 , upstream_port 8080 }
#
define nginx::vhost::proxy (
  $port            = '80',
  $priority        = '10',
  $template        = 'nginx/vhost-proxy.conf.erb',
  $upstream_server = 'localhost',
  $upstream_port   = '8080',
  $servername      = '',
  $ssl             = false,
  $ssl_port        = '443',
  $magic           = '',
  $isdefaultvhost  = false,
  $ssl_path        = '',
  $ssl_cert_file   = '',
  $ssl_key_file    = ''
) {

  include nginx
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

  if $servername == '' {
    $srvname = $name
  } else {
    $srvname = $servername
  }

  file { "${nginx::params::vdir}/${priority}-${name}_proxy":
    content => template($template),
    owner   => 'root',
    group   => '0',
    mode    => '755',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

}
