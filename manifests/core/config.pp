#/etc/puppet/modules/mailman3/manifests/core/config.pp

# == Class mailman3::core::config
#
# === Parameters 
#
# ( As this list is so long it has been alpha sorted, to hopefully make it easier parse with the naked eye)
#
# [*siteowner*]
#  This address is the "site owner" address.  Certain messages which must be
#  delivered to a human, but which can't be delivered to a list owner (e.g. a
#  bounce from a list owner), will be sent to this address.  It should point to
#  a human.

class mailman3::core::config (
  $siteowner   = 'root@localhost', # Set a default address that should be safe.


) {

}
