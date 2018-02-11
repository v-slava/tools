##############################################
# $Id: myUtilsTemplate.pm 7570 2015-01-14 18:31:44Z rudolfkoenig $
#
# Save this file as 99_myUtils.pm, and create your own functions in the new
# file. They are then available in every Perl expression.

package main;

use strict;
use warnings;
use POSIX;

sub
myUtils_Initialize($$)
{
  my ($hash) = @_;
}

# Enter you functions below _this_ line.

sub UDP_Msg($$)
{
  my ($dest,$cmd)  = @_;
  eval "require IO::Socket::INET";
  if($@) {
    Log 1, $@;
    return "Can't load IO::Socket::INET"
  }

  my $sock = IO::Socket::INET->new(
    Proto    => 'udp',
    PeerPort => 60666,
    PeerAddr => $dest
  );
 
  if(!$sock) {
    return "something went wrong"
  }

  $sock->send($cmd);
  $sock->close();

  return "send $cmd"
}

######## DebianMail  Mail auf dem RPi versenden ############ 
sub 
DebianMail 
{ 
 my $rcpt = shift;
 my $subject = shift; 
 my $text = shift;
 my $attach = shift; 
 my $ret = "";
 my $sender = "homematic\@christiantarne.de"; 
 my $konto = "homematic\@christiantarne.de";
 my $passwrd = "Elohopage581";
 my $provider = "smtp.strato.de:587";
 Log 1, "sendEmail RCP: $rcpt";
 Log 1, "sendEmail Subject: $subject";
 Log 1, "sendEmail Text: $text";
 Log 1, "sendEmail Anhang: $attach";
 
 $ret .= qx(sendEmail -f '$sender' -t '$rcpt' -u '$subject' -m '$text' -a $attach -s '$provider' -xu '$konto' -xp '$passwrd' -o tls=auto -o message-charset=utf-8);
 $ret =~ s,[\r\n]*,,g;    # remove CR from return-string 
 Log 1, "sendEmail returned: $ret"; 
}

1;
