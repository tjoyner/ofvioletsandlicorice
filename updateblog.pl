use strict;

use Storable;
use WWW::Tumblr;

my $consumer_key = $ENV{'CONSUMER_KEY'};
my $secret_key = $ENV{'SECRET_KEY'};
my $token = $ENV{'TOKEN'};
my $token_secret = $ENV{'TOKEN_SECRET'};

my $num_args = $#ARGV + 1;
if ($num_args != 3) {
    print "\nUsage: updateblog.pl id file\n";
    exit;
}
my $id = $ARGV[0];
my $file = $ARGV[1];
my $title = $ARGV[2];

my $t = WWW::Tumblr->new(
  consumer_key    => $consumer_key,
  secret_key      => $secret_key,
  token           => $token,
  token_secret    => $token_secret,
);
 
my $blog = $t->blog('ofvioletsandlicorice.tumblr.com');

my $string = '';
{
  local $/=undef;
  open FILE, $file or die "Couldn't open file: $!";
  $string = <FILE>;
  close FILE;
}


my $post = $blog->post_edit(
  type => 'text',
  id => $id,
  body => $string,
  title => $title,
  #data => [ 'content.txt' ],
);
if ($post) {
  print "$file uploaded OK\n";
} else {
  print "$file not OK " . $blog->error . "\n";
}
