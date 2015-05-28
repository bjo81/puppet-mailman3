#/etc/puppet/modules/mailman3/manifests/hyperkitty.pp

class mailman3::hyperkitty (
  $packages    = [],
  $username    = 'hyperkitty',
  $groupname   = 'hyperkitty',
  $installroot = '/usr/local/mailman3-hyperkitty',
) inherits ::mailman3::params {

  include mailman3

  package { $packages:
    ensure => present,
  }

  file {
    $installroot:
      ensure => directory,
      owner  => $username,
      group  => $groupname,
      mode   => '0755';
    "${installroot}/hyperkitty.txt":
      ensure => present,
      owner  => $username,
      group  => $groupname,
      mode   => '0644',
      source => 'puppet:///modules/mailman3/requirements/hyperkitty.txt',
  }

  python::virtualenv {
    "${installroot}/venv2":
      ensure       => present,
      requirements => "${installroot}/hyperkitty.txt",
      owner        => $username,
      group        => $groupname,
      require      => File["${installroot}/hyperkitty.txt"],
  }
}
