# Class: nginx::server
#
#   Install and run the nginx webserver.
#
# Requires:
#
class nginx::server (
  $threadcount                   = $nginx::params::threadcount,
  $server_names_hash_bucket_size = $nginx::params::server_names_hash_bucket_size,
  $default_ssl_cert              = undef,
  $default_ssl_key               = undef,
  $default_ssl_chain             = undef,
  $default_ssl_ca                = undef,
  $default_ssl_crl_path          = undef,
  $default_ssl_ciphers           = $nginx::params::ssl_ciphers,
  $default_ssl_protocols         = $nginx::params::ssl_protocols,
  $default_ssl_verify_client     = undef,
  $serveradmin                   = 'root@localhost',
  $default_webroot               = $nginx::params::default_webroot,
  $ensure                        = 'present',
) inherits nginx::params {

  include nginx
  include nginx::params

  package{ 'nginx':
    ensure => $ensure,
    name   => $nginx::params::package,
  }

  service{ 'nginx':
    ensure     => running,
    name       => $nginx::params::service,
    enable     => true,
    hasstatus  => $nginx::params::hasstatus,
    hasrestart => $nginx::params::hasrestart,
    restart    => $nginx::params::restart,
    subscribe  => Package['nginx'],
  }

  file {
    $nginx::params::vdir:
      ensure  => directory,
      recurse => true,
      purge   => true,
      notify  => Service['nginx'],
      require => Package['nginx'];
    "${nginx::params::etcdir}/nginx.conf":
      content => template( 'nginx/nginx.conf.erb' ),
      owner   => 'root',
      mode    => '0644',
      notify  => Service['nginx'],
      require => Package['nginx'];
    '/var/log/nginx':
      ensure  => directory,
      owner   => $user,
      group   => '0';
    '/var/log/nginx/access.log':
      ensure  => file,
      owner   => $user,
      group   => '0',
      mode    => '0644',
      replace => false;
    '/var/log/nginx/error.log':
      ensure  => file,
      owner   => $user,
      group   => '0',
      mode    => '0644',
      replace => false;
  }
}
