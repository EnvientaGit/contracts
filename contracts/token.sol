pragma solidity ^0.4.11;

contract EnvientaToken {

  string public constant symbol = "ENV";
  string public constant name = "ENVIENTA token";
  uint8 public constant decimals = 18;
  
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval( address indexed owner, address indexed spender, uint256 value);

  mapping( address => uint256 ) _balances;
  mapping( address => mapping( address => uint256 ) ) _approvals;
  
  uint256 public _supply = 30000000 * 10**uint256(decimals);
  
  constructor() public {
    _balances[msg.sender] = _supply;
  }
  
  function totalSupply() public constant returns (uint256 supply) {
    return _supply;
  }
  
  function balanceOf( address who ) public constant returns (uint256 value) {
    return _balances[who];
  }
  
  function transfer( address to, uint256 value) public returns (bool ok) {
    require( _balances[msg.sender] >= value );
    require( _balances[to] + value >= _balances[to]);
    _balances[msg.sender] -= value;
    _balances[to] += value;
    emit Transfer( msg.sender, to, value );
    return true;
  }
  
  function transferFrom( address from, address to, uint256 value) public returns (bool ok) {
    require( _balances[from] >= value );
    require( _approvals[from][msg.sender] >= value );
    require( _balances[to] + value >= _balances[to]);
    _approvals[from][msg.sender] -= value;
    _balances[from] -= value;
    _balances[to] += value;
    emit Transfer( from, to, value );
    return true;
  }
  
  function approve(address spender, uint256 value) public returns (bool ok) {
    _approvals[msg.sender][spender] = value;
    emit Approval( msg.sender, spender, value );
    return true;
  }
  
  function allowance(address owner, address spender) public constant returns (uint256 _allowance) {
    return _approvals[owner][spender];
  }
  
}
