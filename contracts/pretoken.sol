pragma solidity ^0.4.11;

interface token {
  function transfer( address to, uint256 value) public returns (bool ok);
}

contract EnvientaPreToken {

  string public constant symbol = "pENV";
  string public constant name = "ENVIENTA pre-token";
  uint8 public constant decimals = 18;
  
  event pTransfer(address indexed from, address indexed to, uint256 value);

  mapping( address => uint256 ) _balances;
  
  uint256 public _supply = 1200000 * 10**uint256(decimals);
  address _creator;
  token public backingToken;
  bool _buyBackMode = false;
  
  function EnvientaPreToken() public {
    _creator = msg.sender;
    _balances[msg.sender] = _supply;
  }
  
  function totalSupply() public constant returns (uint256 supply) {
    return _supply;
  }
  
  function balanceOf( address who ) public constant returns (uint256 value) {
    return _balances[who];
  }
  
  function enableBuyBackMode(address _backingToken) public {
    require( msg.sender == _creator );
    
    backingToken = token(_backingToken);
    _buyBackMode = true;
  }
  
  function disableBuyBackMode() public {
    require( msg.sender == _creator );
    
    _buyBackMode = false;
  }
  
  function transfer( address to, uint256 value) public returns (bool ok) {
    require( _balances[msg.sender] >= value );
    require( _balances[to] + value >= _balances[to]);
    
    if( _buyBackMode ) {
        require( to == address(this) );
        
        _balances[msg.sender] -= value;
        _balances[to] += value;
        pTransfer( msg.sender, to, value );
        
        backingToken.transfer(msg.sender, value);
        return true;
    } else {
        require( msg.sender == _creator );
        
        _balances[msg.sender] -= value;
        _balances[to] += value;
        pTransfer( msg.sender, to, value );
        return true;
    }
  }
  
}