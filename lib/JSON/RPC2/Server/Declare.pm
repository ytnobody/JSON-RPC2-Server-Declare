package JSON::RPC2::Server::Declare;
use strict;
use warnings;
our $VERSION = '0.01';

use SUPER;
use parent qw/ JSON::RPC2::Server Exporter Class::Accessor::Fast /;

our @EXPORT = qw/ 
    jsonrpc 
    register
    register_nb
    build_res
/;

our $ROUTER;

__PACKAGE__->mk_accessors( qw/ res_builder / );

sub execute {
    my ( $self, $json, $cb ) = @_;
    my $next = $self->super( 'execute' );
    $cb ||= $self->res_builder;
    $next->( $self, $json, $cb );
}

sub jsonrpc (&) {
    local $ROUTER = JSON::RPC2::Server::Declare->new;
    shift->();
    return $ROUTER;
}

sub register ($&) {
    my ( $method, $code ) = @_;
    my $next = $ROUTER->super( 'register' );
    $next->( $ROUTER, $method => $code );
}

sub register_nb ($&) {
    my ( $method, $code ) = @_;
    my $next = $ROUTER->super( 'register_nb' );
    $next->( $ROUTER, $method => $code );
}

sub build_res (&) {
    my ( $code ) = @_;
    $ROUTER->res_builder( $code );
}

1;
__END__

=head1 NAME

JSON::RPC2::Server::Declare - DSL-ish interface for JSON::RPC2::Server

=head1 SYNOPSIS

  use JSON::RPC2::Server::Declare;
  
  my $server = jsonrpc {
      register 'user.add' => sub {
          my @params = @_;
          ...
          return $json_res;
      };
      
      register_nb 'user.fetch' => sub {
          my @params = @_;
          ...
          return $json_res;
      };
      
      build_res {
          my ( $json_res ) = @_;
          # send $json_res somehow
      };
  };
  
  $server->execute( $json_str );

=head1 DESCRIPTION

JSON::RPC2::Server::Declare presents DSL-ish interface for building JSON-RPC 2.0 API.

=head1 COMMANDS

=head2 jsonrpc CODE

Returns a JSON::RPC2::Server::Declare object.

    my $server = jsonrpc {
        ### SOME CODES HERE ###
    };

=head2 register STR => CODE

It works as register() of JSON::RPC2::Server.

    jsonrpc {
        register 'mymethod' => sub {
            my %params = @_;
            return { name => $params{name}, age => $params{age} };
        };
    };

=head2 register_nb STR => CODE

It works as register_nb() of JSON::RPC2::Server.

    my $count = 0;
    jsonrpc {
        register_nb 'myiter' => sub {
            my %params = @_;
            $count++;
            return { ok => 1 };
        };
    };

=head2 build_res CODE

A coderef used when call execute().

    my $server = {
        build_res {
            my ( $json_str ) = @_;
            say $json_str;
        };
    };

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=head1 SEE ALSO

=over

=item L<lt>JSON::RPC2::ServerL<gt>

=back

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
