#/etc/puppet/modules/mailman_asf/manifests/postorius.pp

class mailman_asf::postorius (
  $packages  = [],
  $username  = 'postorius',
  $groupname = 'postorius',
) {

  include mailman_asf

  package { $packages:
    ensure => present,
  }

  file { "/home/${username}/postorius.txt":
    ensure => present,
    owner  => $username,
    group  => $groupname,
    mode   => '0644',
    source => 'puppet:///modules/mailman_asf/requirements/postorius.txt',
  }

  python::virtualenv { "/home/${username}/venv2":
    ensure       => present,
    requirements => "/home/${username}/postorius.txt",
    owner        => $username,
    group        => $groupname,
    require      => File["/home/${username}/postorius.txt"],
  }
}
