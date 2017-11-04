pragma solidity ^0.4.11;

contract EnvientaToken {

  string public constant symbol = "ENV";
  string public constant name = "ENVIENTA token";
  uint8 public constant decimals = 18;
  
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval( address indexed owner, address indexed spender, uint256 value);

  mapping( address => uint256 ) _balances;
  mapping( address => mapping( address => uint256 ) ) _approvals;
  
  uint256 public _supply = 1200000 * 10**uint256(decimals);
  
  function EnvientaToken() {
    _balances[msg.sender] = _supply;
  }
  
  function totalSupply() constant returns (uint256 supply) {
    return _supply;
  }
  
  function balanceOf( address who ) constant returns (uint256 value) {
    return _balances[who];
  }
  
  function transfer( address to, uint256 value) returns (bool ok) {
    if( _balances[msg.sender] < value ) {
      throw;
    }
    if( !safeToAdd(_balances[to], value) ) {
      throw;
    }
    _balances[msg.sender] -= value;
    _balances[to] += value;
    Transfer( msg.sender, to, value );
    return true;
  }
  
  function transferFrom( address from, address to, uint256 value) returns (bool ok) {
    if( _balances[from] < value ) {
      throw;
    }
    if( _approvals[from][msg.sender] < value ) {
      throw;
    }
    if( !safeToAdd(_balances[to], value) ) {
      throw;
    }
    _approvals[from][msg.sender] -= value;
    _balances[from] -= value;
    _balances[to] += value;
    Transfer( from, to, value );
    return true;
  }
  
  function approve(address spender, uint256 value) returns (bool ok) {
    _approvals[msg.sender][spender] = value;
    Approval( msg.sender, spender, value );
    return true;
  }
  
  function allowance(address owner, address spender) constant returns (uint256 _allowance) {
    return _approvals[owner][spender];
  }
  
  function safeToAdd(uint256 a, uint256 b) internal returns (bool) {
    return (a + b >= a);
  }
}
