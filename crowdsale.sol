pragma solidity ^0.4.11;

interface token {
  function transfer( address to, uint256 value) public returns (bool ok);
  function balanceOf( address who ) public constant returns (uint256 value);
}

contract EnvientaCrowdsale {

    uint public softCap = 1000 ether;
    uint public hardCap = 5000 ether;
    uint public duration = 30 days;

    uint public bonusLevel1 = 1000 ether;
    uint public bonusLevel2 = 2000 ether;
    
    uint public rewardLevel1 = 130;
    uint public rewardLevel2 = 115;
    uint public rewardLevel3 = 100;
    
    address public owner;
    uint public amountRaised;
    uint public deadline;
    token public tokenReward;
    mapping(address => uint256) public balanceOf;
    bool fundingGoalReached = false;
    bool crowdsaleClosed = false;
    bool crowdsaleStarted = false;

    event GoalReached(address recipient, uint totalAmountRaised);
    event FundTransfer(address backer, uint amount, bool isContribution);

    modifier onlyOwner {
      require(msg.sender == owner);
      _;
    }
    
    function EnvientaCrowdsale() public {
        owner = msg.sender;
    }

    function start( address tokenRewardAddress ) public onlyOwner {
      tokenReward = token(tokenRewardAddress);
      deadline = now + duration;
      crowdsaleStarted = true;
    }
    
    function stop() public onlyOwner {
      if( amountRaised >= softCap ) {
	    fundingGoalReached = true;
	    GoalReached(owner, amountRaised);
      }
      crowdsaleClosed = true;
    }
    

    function checkGoalReached() public {
      require( crowdsaleStarted );
      require( now >= deadline );
      if( amountRaised >= softCap ) {
	    fundingGoalReached = true;
	    GoalReached(owner, amountRaised);
      }
      crowdsaleClosed = true;
    }

    function _sell(uint currentAmount, uint rewardMultiplier) internal {
    	balanceOf[msg.sender] += currentAmount;
    	amountRaised += currentAmount;
    	tokenReward.transfer(msg.sender, currentAmount * rewardMultiplier);
        FundTransfer(msg.sender, currentAmount, true);
    }
    
    function () public payable {
      require( crowdsaleStarted );
      require( !crowdsaleClosed );
      require( now < deadline );
      require( amountRaised <= hardCap );
	
      uint amount = msg.value;
      uint currentAmount = 0;
        
      if( amountRaised < bonusLevel1 && amount > 0) {
    	if( amountRaised + amount > bonusLevel1 ) {
    	  currentAmount = bonusLevel1 - amountRaised;
    	  amount = amount - currentAmount;
    	} else {
    	  currentAmount = amount;
    	  amount = 0;
    	}
    	_sell(currentAmount, rewardLevel1);
      }
      
      if( amountRaised < bonusLevel2 && amount > 0) {
    	if( amountRaised + amount > bonusLevel2 ) {
    	  currentAmount = bonusLevel2 - amountRaised;
    	  amount = amount - currentAmount;
    	} else {
    	  currentAmount = amount;
    	  amount = 0;
    	}
    	_sell(currentAmount, rewardLevel2);
      }
      
      if( amount > 0 ) {
    	if( amountRaised + amount > hardCap ) {
    	  currentAmount = hardCap - amountRaised;
    	  amount = amount - currentAmount;
    	} else {
    	  currentAmount = amount;
    	  amount = 0;
    	}
    	_sell(currentAmount, rewardLevel3);
      }
      
      if( amount > 0 ) {
    	msg.sender.transfer(amount);
      }
    }

    function safeWithdrawal() public {
      require( crowdsaleStarted );
      require( crowdsaleClosed );
      
      if( !fundingGoalReached ) {
    	uint amount = balanceOf[msg.sender];
    	balanceOf[msg.sender] = 0;
        if (amount > 0) {
    	  msg.sender.transfer(amount);
    	  FundTransfer(msg.sender, amount, false);
        }
      }

      if (fundingGoalReached && owner == msg.sender) {
    	owner.transfer(amountRaised);
    	tokenReward.transfer(owner, tokenReward.balanceOf(this));
    	FundTransfer(owner, amountRaised, false);
      }
    }
    
}
