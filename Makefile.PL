use inc::Module::Install;
name 'JSON-RPC2-Server-Declare';
all_from 'lib/JSON/RPC2/Server/Declare.pm';

requires 'JSON::RPC2::Server';

tests 't/*.t';

test_requires 'JSON';
test_requires 'Test::More';

auto_include;
WriteAll;
