package Hubot::Scripts::dic;

use utf8;
use strict;
use warnings;
use Encode;
use Data::Printer;

sub load {
    my ( $class, $robot ) = @_;
 
    $robot->hear(
        qr/^dic (.*)/i,    
        \&dic_process,
    );
}

sub dic_process {
    my $msg = shift;
    my $user_input = $msg->match->[0];
    print "$user_input\n";

    $msg->http("http://dic.naver.com/search.nhn?dicQuery=$user_input&query=$user_input&target=dic&ie=utf8&query_utf=&isOnlyViewEE=")->get(
            sub { 
                my ( $body, $hdr )  = @_;
                return if ( !$body || $hdr->{Status} !~ /^2/ );
                my $decode_body = decode ("utf-8", $body);

                if ( $decode_body =~ m{<span class="word_class">(.*)</span>} ) {
                    my $word_class = $1;
                    $msg->send($word_class);
                }
                my @word_a_define =  $decode_body =~ m{<br>\s*\d{1,}\.\s*(.+)\s*<br>}g; 
                #my @word_a_define =  $decode_body =~ m{<br>[\s.\d]*(.+)\s*<br>}g; 

                p @word_a_define;

            }
        );
}
1;

=pod

=head1 Name 

    Hubot::Scripts::dic
 
=head1 SYNOPSIS

    dic <word> 

=head1 AUTHOR

    YunChang Kang <codenewb@gmail.com>
 
=cut
