#/etc/puppet/modules/mailman3/manifests/postorius.pp

class mailman3::postorius (
  $packages  = [],
  $username  = 'postorius',
  $groupname = 'postorius',
) {

  include mailman3

  package { $packages:
    ensure => present,
  }

  file { "/home/${username}/postorius.txt":
    ensure => present,
    owner  => $username,
    group  => $groupname,
    mode   => '0644',
    source => 'puppet:///modules/mailman3/requirements/postorius.txt',
  }

  python::virtualenv { "/home/${username}/venv2":
    ensure       => present,
    requirements => "/home/${username}/postorius.txt",
    owner        => $username,
    group        => $groupname,
    require      => File["/home/${username}/postorius.txt"],
  }
}
