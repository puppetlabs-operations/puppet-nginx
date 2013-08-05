# Class: nginx::server
#
#   Install and run the nginx webserver.
#
# Requires:
#
# Debian/ubuntu at present.
#
class nginx::server (
  $threadcount                   = $nginx::params::threadcount,
  $server_names_hash_bucket_size = $nginx::params::server_names_hash_bucket_size,
  $default_ssl_path              = $nginx::params::default_ssl_path,
  $default_ssl_cert              = $nginx::params::default_ssl_cert,
  $default_ssl_key               = $nginx::params::default_ssl_key,
  $default_ssl_chain             = undef,
  $default_ssl_ca                = undef,
  $default_ssl_crl_path          = undef,
  $serveradmin                   = 'root@localhost',
  $default_webroot               = $nginx::params::default_webroot,
  $ensure                        = 'present',
) inherits nginx::params {

  include nginx
  include nginx::params

  # Platform specific server setup items
  case $operatingsystem {
    'debian': { include nginx::server::debian }
  }

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

  # All the files, stolen from debian, hence this being debian
  # specific at the minute.
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
  }

}
