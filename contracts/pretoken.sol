pragma solidity ^0.4.11;

interface token {
  function transfer( address to, uint256 value) public returns (bool ok);
}

contract EnvientaPreToken {

  string public constant symbol = "pENV";
  string public constant name = "ENVIENTA pre-token";
  uint8 public constant decimals = 18;
  
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval( address indexed owner, address indexed spender, uint256 value);

  mapping( address => uint256 ) _balances;
  mapping( address => mapping( address => uint256 ) ) _approvals;
  
  uint256 public _supply = 1200000 * 10**uint256(decimals);
  address _creator;
  token _backingToken;
  bool _buyBackMode = false;
  
  function EnvientaToken() public {
    _creator = msg.sender;
    _balances[msg.sender] = _supply;
  }
  
  function totalSupply() public constant returns (uint256 supply) {
    return _supply;
  }
  
  function balanceOf( address who ) public constant returns (uint256 value) {
    return _balances[who];
  }
  
  function enableBuyBackMode(address backingToken) public {
    require( msg.sender == _creator );
    
    _backingToken = token(backingToken);
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
        Transfer( msg.sender, to, value );
        
        _backingToken.transfer(to, value);
        return true;
    } else {
        require( msg.sender == _creator );
        
        _balances[msg.sender] -= value;
        _balances[to] += value;
        Transfer( msg.sender, to, value );
        return true;
    }
  }
  
}