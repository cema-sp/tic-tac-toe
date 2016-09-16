# Tic-Tac-Toe

Ehereum Tic-Tac-Toe game on Smart Contracts.

# Info

__Contacts__:
  
- TicTacToe:

    - 0x5cD479646F8A705ACD69C4e48aB1B7704CC4A0c2

__Accounts__:

- 0xad0934806D7602147cb23Db9829c335Bea613bcc : pass

# Development

Prepare chain:

1. `geth --datadir ./test/chain init ./test/genesis.json`

Mine some ether:  
`miner.start(1); admin.sleepBlocks(12); miner.stop();`

1. `solc --bin --abi --optimize ./index.sol`
2. `geth --nodiscover --maxpeers 0 --rpc --rpcapi "eth,net,web3" --datadir ./test/chain console 2>> ./tmp/geth.log`
3. `/Applications/Mist.app/Contents/MacOS/Mist --rpc ./test/chain/geth.ipc`

To run console on testnet:  
`geth --fast --cache=512 --jitvm --testnet --unlock=0 console 2>> ./tmp/geth.log`

```
const Web3 = require('web3')
const web3 = new Web3()

web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'))

web3.isConnected()

const abi = [{"constant":false,"inputs":[],"name":"newGame","outputs":[{"name":"hash","type":"bytes32"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"destroy","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"hash","type":"bytes32"}],"name":"joinGame","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"games","outputs":[{"name":"user","type":"address"},{"name":"idx","type":"uint256"}],"payable":false,"type":"function"},{"payable":false,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"hash","type":"bytes32"}],"name":"LogNewGame","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"hash","type":"bytes32"}],"name":"LogGameStarted","type":"event"}]
const addr = '0x5cD479646F8A705ACD69C4e48aB1B7704CC4A0c2'
const tic = web3.eth.contract(abi).at(addr)
```
