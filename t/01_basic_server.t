use strict;
use Test::More;
use JSON;

use JSON::RPC2::Server::Declare;

my $response;
my $counter = 0;

my $server = jsonrpc {
    register rpc_sum => sub { $_[0] + $_[1] };
    register rpc_double => sub { $_[0] * 2 };
    register_nb cnt => sub { $counter++ };
    build_res { $response = from_json( shift ) };
};

### this logic emulates jsonrpc-2.0 request.
sub jsonrpc_req {
    my ( $method, @data ) = @_;
    return to_json( {
        jsonrpc => '2.0',
        id => time,
        method => $method,
        params => [ @data ],
    } );
}

isa_ok $server, 'JSON::RPC2::Server';

my $jsonreq = jsonrpc_req( qw/ rpc_sum 2 3 / );
$server->execute( $jsonreq );
is $response->{result}, 5;

$jsonreq = jsonrpc_req( qw/ rpc_double 24 / );
$server->execute( $jsonreq );
is $response->{result}, 48;

$jsonreq = jsonrpc_req( qw/ cnt / );
$server->execute( $jsonreq );
is $counter, 1;

done_testing;
