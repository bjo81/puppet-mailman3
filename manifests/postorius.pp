#/etc/puppet/modules/mailman3/manifests/postorius.pp

class mailman3::postorius (
  $packages  = [],
  $username  = 'postorius',
  $groupname = 'postorius',
  $installroot = '/usr/local/mailman3-postorius',
) inherits ::mailman3::params {

  include mailman3

  package { $packages:
    ensure => present,
  }

  file {
    $installroot:
      ensure => present,
      owner  => $username,
      group  => $groupname,
      mode   => '0755';
    "${installroot}/postorius.txt":
      ensure => present,
      owner  => $username,
      group  => $groupname,
      mode   => '0644',
      source => 'puppet:///modules/mailman3/requirements/postorius.txt';
  }

  python::virtualenv {
    "${installroot}/venv2":
      ensure       => present,
      requirements => "${installroot}/postorius.txt",
      owner        => $username,
      group        => $groupname,
      require      => File["${installroot}/postorius.txt"],
  }
}
