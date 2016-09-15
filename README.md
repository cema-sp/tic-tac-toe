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
2. `geth --nodiscover --maxpeers 0 --datadir ./test/chain console 2>> ./tmp/geth.log`

To run console on testnet:  
`geth --fast --cache=512 --jitvm --testnet --unlock=0 console 2>> ./tmp/geth.log`
