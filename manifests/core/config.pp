#/etc/puppet/modules/mailman3/manifests/core/config.pp

# == Class mailman3::core::config
#
# === Parameters 
#
# ( As this list is so long it has been alpha sorted, to hopefully make it easier parse with the naked eye)
#
# [*defaultlanguage*]
#  The default language for this server.
#
# [*emailcmdsmaxlines*]
#  Mail command processor will ignore mail command lines after designated max.
#
# [*layout*]
#  Which paths.* file system layout to use.
#
# [*noreplyaddress*]
#  This is the local-part of an email address used in the From field whenever a
#  message comes from some entity to which there is no natural reply recipient.
#  Mailman will append '@' and the host name of the list involved.  This
#  address must not bounce and it must not point to a Mailman process.
#
# [*pendingrequestlife*]
#  Default length of time a pending request is live before it is evicted from
#  the pending database.
#
# [*posthook*]
#  A callable to run with no arguments late in the initialization process.
#  This runs after adapters are initialized.
#
# [*prehook*]
#  A callable to run with no arguments early in the initialization process.
#  This runs before database initialization.

# [*senderheaders*]
#  Membership tests for posting purposes are usually performed by looking at a
#  set of headers, passing the test if any of their values match a member of
#  the list.  Headers are checked in the order given in this variable.  The
#  value From_ means to use the envelope sender.  Field names are case
#  insensitive.  This is a space separate list of headers.
#
# [*siteowner*]
#  This address is the "site owner" address.  Certain messages which must be
#  delivered to a human, but which can't be delivered to a list owner (e.g. a
#  bounce from a list owner), will be sent to this address.  It should point to
#  a human.

class mailman3::core::config (
  $defaultlanguage    = 'en',
  $emailcmdsmaxlines  = '10',
  $layouts            = 'here',
  $noreplyaddress     = 'noreply', # See comment at the top for usage instructions.
  $pendingrequestlife = '3d',
  $posthook           = '',
  $prehook            = '',
  $senderheaders      = 'from from_ reply-to sender',
  $siteowner          = 'root@localhost', # Set a default address that should be safe.


) {

}
