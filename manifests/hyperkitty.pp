#/etc/puppet/modules/mailman3/manifests/hyperkitty.pp

class mailman3::hyperkitty (
  $packages  = [],
  $username  = 'hyperkitty',
  $groupname = 'hyperkitty',
) {

  include mailman3

  package { $packages:
    ensure => present,
  }

  file { "/home/${username}/hyperkitty.txt":
    ensure => present,
    owner  => $username,
    group  => $groupname,
    mode   => '0644',
    source => 'puppet:///modules/mailman3/requirements/hyperkitty.txt',
  }

  python::virtualenv { "/home/${username}/venv2":
    ensure       => present,
    requirements => "/home/${username}/hyperkitty.txt",
    owner        => $username,
    group        => $groupname,
    require      => File["/home/${username}/hyperkitty.txt"],
  }
}
