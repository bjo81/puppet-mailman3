F1abb3rG@st3d#/etc/puppet/modules/mailman3/manifests/core/config.pp

# == Class mailman3::core::config
#
# === Parameters 
#
# ( As this list is so long it has been alpha sorted, to hopefully make it easier parse with the naked eye)
#
# [*archivedir*]
#  Directory for archive backends to store their messages in.  Archivers should
#  create a subdirectory in here to store their files.
#
# [*bindir*]
#  This is the directory containing the Mailman 'runner' and 'master' commands
#  if set to the string '$argv', it will be taken as the directory containing
#  the 'mailman' command.
#
# [*datadir*]
#  Directory for system-wide data.
#
# [*defaultlanguage*]
#  The default language for this server.
#
# [*devmodeenabled*]
# Setting enabled to true enables certain safeguards and other behavior
# changes that make developing Mailman easier.  For example, it forces the
# SMTP RCPT TO recipients to be a test address so that no messages are
# accidentally sent to real addresses.
#
# [*devmoderecipient*]
# Set this to an address to force the SMTP RCPT TO recipents when devmode is
# enabled.  This way messages can't be accidentally sent to real addresses.
#
# [*devmodetesting*]
# This gets set by the testing layers so that the runner subprocesses produce
# predictable dates and times.
#
# [*devmodewait*]
# Time-outs for starting up various test subprocesses, such as the LMTP and
# REST servers.  This is only used for the test suite, so if you're seeing
# test failures, try increasing the wait time.
#
# [*emailcmdsmaxlines*]
#  Mail command processor will ignore mail command lines after designated max.
#
# [*etcdir*]
#  Directory for configuration files and such.
#
# [*extdir*]
#  Directory containing Mailman plugins.
#
# [*layout*]
#  Which paths.* file system layout to use.
#
# [*listdatadir*]
#  All list-specific data.
#
# [*lockdir*]
#  Directory for system-wide locks.
#
# [*lockfile*]
#  Lock file.
#
# [*logdir*]
#  Directory where log files go.
#
# [*messagesdir*]
#  Directory where the default IMessageStore puts its messages.
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
# [*pidfile*]
#  This is where PID file for the master runner is stored.
#
# [*posthook*]
#  A callable to run with no arguments late in the initialization process.
#  This runs after adapters are initialized.
#
# [*prehook*]
#  A callable to run with no arguments early in the initialization process.
#  This runs before database initialization.
#
# [*preservefiliteredmime*]
#  Can MIME filtered messages be preserved by list owners?
#
# [*queuedir*]
#  This is where the Mailman queue files directories will be created.
#
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
#
# [*templatedir*]
#  Root directory for site-specific template override files.
#
# [*vardir*]
#  This is the root of the directory structure that Mailman will use to store
#  its run-time data.
#


class mailman3::core::config (
  $archivedir               = '$var_dir/archives',
  $bindir                   = '$argv',
  $databaseclass            = 'mailman.database.postgresql.PostgreSQLDatabase',
  $databasedebug            = 'no',
  $databaseurl              = 'postgres://user:password@localhost/mailman',
  $datadir                  = '$var_dir/data',
  $defaultlanguage          = 'en',
  $devmodenabled            = 'no',
  $devmoderecipient         = '',
  $devmodetesting           = 'no',
  $devmodewait              = '60s',
  $emailcmdsmaxlines        = '10',
  $etcdir                   = '$var_dir/etc',
  $extdir                   = '$var_dir/ext',
  $layouts                  = 'here',
  $listdatadir              = '$var_dir/lists',
  $lockdir                  = '$var_dir/locks',
  $lockfile                 = '$lock_dir/master.lck',
  $logdir                   = '$var_dir/logs',
  $loggingbouncelevel       = 'info',
  $loggingbouncepath        = 'bounce.log',
  $loggingdatabaselevel     = 'warn',
  $loggingdatabasepath      = 'database.log',
  $loggingdebuglevel        = 'info',
  $loggingdebugpath         = 'debug.log',
  $loggingsmtplevel         = 'info',
  $loggingsmtpmsgevery      = '$msgid smtp to $listname for $recip recips, completed in $time seconds',
  $loggingsmtpmsgfailure    = '$msgid delivery to $recip failed with code $smtpcode, $smtpmsg',
  $loggingsmtpmsgrefused    = '$msgid post to $listname from $sender, $size bytes, $refused failures',
  $loggingsmtpmsgsuccess    = '$msgid post to $listname from $sender, $size bytes',
  $loggingsmtppath          = 'smtp.log',
  $loggingtemplateformat    = '%(asctime)s (%(process)d) %(message)s',
  $loggingtemplatedatefmt   = '%b %d %H:%M:%S %Y',
  $loggingtemplatepropagate = 'no',
  $loggingtemplatelevel     = 'info',
  $loggingtemplatepath      = 'mailma.log',
  $mailmancfgfile           = '/etc/mailman.cfg',
  $masterclass              = 'mailman.core.runner.Runner',
  $masterinstances          = '1',
  $mastermaxrestarts        = '10',
  $masterpath               = '$QUEUE_DIR/$name',
  $mastersleeptime          = '1s',
  $masterstart              = 'yes',
  $messagesdir              = '$var_dir/messages',
  $noreplyaddress           = 'noreply', # See comment at the top for usage instructions.
  $passwordconfig           = 'python:mailman.config.passlib',
  $passwordlength           = '8',
  $pendingrequestlife       = '3d',
  $pidfile                  = '$var_dir/master.pid',
  $posthook                 = '',
  $prehook                  = '',
  $preservefiliteredmime    = 'no',
  $queuedir                 = '$var_dir/queue',
  $senderheaders            = 'from from_ reply-to sender',
  $siteowner                = 'root@localhost', # Set a default address that should be safe.
  $templatedir              = '$var_dir/templates',
  $vardir                   = '/var/tmp/mailman',



) {

  file {
    $mailmancfgfile:
      ensure  => present,
      content => template('mailman3/mailman.cfg.erb'),
      owner   => $::mailman::core::username,
      group   => $::mailman::core::groupname,
      notify  => Service['mailman'];
  }

}
