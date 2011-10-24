use strict;
use Test::More;
use JSON;

use JSON::RPC2::Server::Declare;
use JSON::RPC2::Client;

my $response;
my $counter = 0;

my $client = JSON::RPC2::Client->new;

my $server = jsonrpc {
    register rpc_sum => sub { $_[0] + $_[1] };
    register rpc_double => sub { $_[0] * 2 };
    register_nb cnt => sub { $counter++ };
    build_res { $response = from_json( shift ) };
};

isa_ok $server, 'JSON::RPC2::Server';

my ( $req, $call ) = $client->call( 'rpc_sum', 2, 3 );
$server->execute( $req );
is $response->{result}, 5;

( $req, $call ) = $client->call( 'rpc_double', 24 );
$server->execute( $req );
is $response->{result}, 48;

( $req, $call ) = $client->call( 'cnt' );
$server->execute( $req );
is $counter, 1;

done_testing;
