#!/bin/bash

ipfs init

ipfs bootstrap rm --all
ipfs bootstrap add /ip4/140.113.110.74/tcp/8311/ipfs/12D3KooWLi3PgpTUaJgQKmPEU5nq2KVmMX3jg1SDwdXMBVAvpqHY
ipfs bootstrap add /ip4/140.113.110.74/tcp/8314/ipfs/12D3KooWC7EB5udob16hQZom3AKJ5BKEXeAeDsZjFoo6sJ8H2RVR

printf "/key/swarm/psk/1.0.0/\n/base16/\n11a33517c22d93cdbb279898d9b01ce095f8ca103a454ac1b21bf785c9e51a9d" > ~/.ipfs/swarm.key