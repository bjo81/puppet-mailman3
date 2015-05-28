#/etc/puppet/modules/mailman_asf/manifests/hyperkitty.pp

class mailman_asf::hyperkitty (
  $packages  = [],
  $username  = 'hyperkitty',
  $groupname = 'hyperkitty',
) {

  include mailman_asf

  package { $packages:
    ensure => present,
  }

  file { "/home/${username}/hyperkitty.txt":
    ensure => present,
    owner  => $username,
    group  => $groupname,
    mode   => '0644',
    source => 'puppet:///modules/mailman_asf/requirements/hyperkitty.txt',
  }

  python::virtualenv { "/home/${username}/venv2":
    ensure       => present,
    requirements => "/home/${username}/hyperkitty.txt",
    owner        => $username,
    group        => $groupname,
    require      => File["/home/${username}/hyperkitty.txt"],
  }
}
