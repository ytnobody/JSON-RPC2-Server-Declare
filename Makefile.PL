use inc::Module::Install;
name 'JSON-RPC2-Server-Declare';
all_from 'lib/JSON/RPC2/Server/Declare.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
