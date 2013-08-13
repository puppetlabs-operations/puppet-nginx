# Class: nginx::params
#
#   class description goes here.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nginx::params {

  $server_names_hash_bucket_size = 32

  # allow people to disable server_tokens - by default we shouldn't
  # leak this information
  $server_tokens = "off"

  case $operatingsystem {
    'debian',
    'ubuntu': {
        $package         = 'nginx'
        $service         = 'nginx'
        $restart         = '/usr/sbin/nginx -t && /etc/init.d/nginx reload'
        $hasrestart      = true
        $hasstatus       = true
        $etcdir          = '/etc/nginx'
        $vdir            = "${etcdir}/sites-enabled"
        $confd           = "${etcdir}/conf.d"
        $threadcount     = $processorcount
        $phpfpm_service  = 'php5-fpm'
        $fastcgi_params  = '/etc/nginx/fastcgi_params'
        $user            = 'www-data'
        $default_webroot = '/var/www'
      }
    'freebsd': {
        $package         = 'nginx'
        $service         = 'nginx'
        $restart         = '/usr/sbin/service nginx reload'
        $hasrestart      = true
        $hasstatus       = true
        $etcdir          = '/usr/local/etc/nginx'
        $vdir            = "${etcdir}/sites-enabled"
        $confd           = "${etcdir}/conf.d"
        $threadcount     = '4'
        $user            = 'www'
        $default_webroot = '/usr/local/www'
      }
    default: {
        warning( "Sorry, nginx module isn't built for ${operatingsystem} yet." )
    }
  }

  include ssl::params
  $default_ssl_path = $ssl::params::ssl_path
  $default_ssl_cert = $ssl::params::ssl_cert_file
  $default_ssl_key  = $ssl::params::ssl_key_file

}
