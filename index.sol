pragma solidity ^0.4.0;

contract owned {
  address private owner;

  function owned() { owner = msg.sender; }

  function destroy() {
    if (msg.sender != owner) throw;
    selfdestruct(owner);
  }
}

/// @title TicTacToe
/// @author cema-sp
contract TicTacToe is owned {
  enum Symbol {
    None,
    Nought,
    Cross
  }

  struct Game {
    address       noughts;
    address       crosses;
    Symbol[3][3]  board;
  }

  struct GameId {
    address user;
    uint    idx;
  }

  mapping (address => Game[]) private userGames;
  mapping (bytes32 => GameId) public games;

  event LogNewGame(bytes32 hash);
  event LogGameStarted(bytes32 hash);

  /// @notice Start a new game
  /// @return Game ID
  function newGame() returns(bytes32 hash) {
    address user = msg.sender;
    uint idx = userGames[user].length;

    Symbol[3][3] memory board;

    userGames[user].push(Game({
      noughts: user,
      crosses: address(0),
      board:   board,
    }));

    hash = sha3(user, idx);
    games[hash] = GameId(user, idx);

    LogNewGame(hash);
  }

  /// @notice Join game with given ID
  function joinGame(bytes32 hash) {
    Game memory game = getGame(hash);

    game.crosses = msg.sender;

    LogGameStarted(hash);
  }

  // function watchGame(bytes32 hash) constant {
  //   Game memory game = getGame(hash);
  // }

  function getGame(bytes32 hash) internal constant returns(Game game) {
    GameId gameId = games[hash];

    if (gameId.user == address(0)) throw;

    game = userGames[gameId.user][gameId.idx];
  }

  function() { throw; }
}
