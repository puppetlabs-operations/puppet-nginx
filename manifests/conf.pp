# Define: nginx::conf
#
#   nginx vhost. For serving web traffic as you would with apache.
#
# Parameters:
#
# Requires:
#   include nginx::server
#
define nginx::conf (
  $template
) inherits nginx::params {

  include nginx

  file { "${nginx::params::confd}/${name}.conf":
    content => template($template),
    owner   => 'root',
    group   => '0',
    mode    => '755',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

}
