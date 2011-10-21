package JSON::RPC2::Server::Declare;
use strict;
use warnings;
our $VERSION = '0.01';

use JSON::RPC2::Server;
use parent qw/ Exporter /;

our @EXPORT = qw/ 
    jsonrpc 
    register
    register_nb
    jsonrpc_res
    exec_rpc
/;

our $ROUTER;
our $RESPONSE;

sub jsonrpc (&) {
    $ROUTER = JSON::RPC2::Server->new;
    shift->();
    return $ROUTER;
}

sub register ($&) {
    my ( $method, $code ) = @_;
    $ROUTER->register( $method => $code );
}

sub regiter_nb ($&) {
    my ( $method, $code ) = @_;
    $ROUTER->register_nb( $method => $code );
}

sub jsonrpc_res (&) {
    $RESPONSE = shift;
}

sub exec_rpc ($) {
    my ( $json ) = @_;
    $ROUTER->execute( $json, $RESPONSE );
}

1;
__END__

=head1 NAME

JSON::RPC2::Server::Declare - DSL-ish interface for JSON::RPC2::Server

=head1 SYNOPSIS

  use JSON::RPC2::Server::Declare;
  
  jsonrpc {
      register 'user.add' => sub {
          my ( $json_req ) = @_;
          ...
          return $json_res;
      };
      register_nb 'user.fetch' => sub {
          my ( $json_req ) = @_;
          ...
          return $json_res;
      };
  };
  
  jsonrpc_res {
      my ( $json_res ) = @_;
      # send $json_res somehow
  };
  
  exec_rpc $json_str;

=head1 DESCRIPTION

JSON::RPC2::Server::Declare presents DSL-ish interface for building JSON-RPC 2.0 API.

=head1 COMMANDS

=head2 jsonrpc

=head2 register

=head2 register_nb

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
