# Puppet-nginx

A puppet module to manage the nginx webserver.

## vHosting


### vHost Redirects

For redirecting traffic using a vHost, consider the following.

    nginx::vhost::redirect { 'newprojects_to_projects':
      servername => 'newprojects.puppetlabs.com',
      port       => 80,
      dest       => 'https://projects.puppetlabs.com/',
    }

This will receive requests destined to 'newprojects.puppetlabs.com' and
redirect them to 'https://projects.puppetlabs.com/'.

