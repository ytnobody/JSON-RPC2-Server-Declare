use strict;
use Test::More;
use JSON;

my $response;

use JSON::RPC2::Server::Declare;

my $counter = 0;

my $server = jsonrpc {
    register rpc_sum => sub { $_[0] + $_[1] };
    register rpc_double => sub { $_[0] * 2 };
    register_nb cnt => sub { $counter++ };
};

jsonrpc_res { $response = from_json( shift ) };

### jsonrpc-2.0 response
my $jsonrpc_res = sub {
    my ( $method, @data ) = @_;
    return to_json( {
        jsonrpc => '2.0',
        id => time,
        method => $method,
        params => [ @data ],
    } );
};

### this logic emulates jsonrpc-2.0 request.
sub jsonrpc_req {
    $jsonrpc_res->( @_ );
}

isa_ok $server, 'JSON::RPC2::Server';
isa_ok $JSON::RPC2::Server::Declare::ROUTER, 'JSON::RPC2::Server';

my $jsonreq = jsonrpc_req( qw/ rpc_sum 2 3 / );
exec_rpc $jsonreq;
is $response->{result}, 5;

$jsonreq = jsonrpc_req( qw/ rpc_double 24 / );
exec_rpc $jsonreq;
is $response->{result}, 48;

$jsonreq = jsonrpc_req( qw/ cnt / );
exec_rpc $jsonreq;
is $counter, 1;

done_testing;
