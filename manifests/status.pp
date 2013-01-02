class nginx::status(
  $monitorport = '70'
) {

  nginx::vhost { "status":
    template         => "nginx/vhost-status.conf.erb",
    template_options => {
      'monitorport'  => $monitorport,
    },
  }

}
