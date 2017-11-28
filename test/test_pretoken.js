var EnvientaToken = artifacts.require("EnvientaToken");
var EnvientaPreToken = artifacts.require("EnvientaPreToken");

contract('EnvientaPreToken', (accounts) => {

  UNIT = Math.pow(10, 18);
  
  let tokenInstance;
  let preTokenInstance;
  
  before(async () => {
    tokenInstance = await EnvientaToken.deployed();
    preTokenInstance = await EnvientaPreToken.deployed();
  });

  it("check initial supply", async () => {
    let balance = await preTokenInstance.balanceOf(accounts[0]);
    assert.equal(balance.valueOf(), 1200000 * UNIT, "1200000 wasn't in the first account");
  });
  
  it("send 100 pENV", async () => {
    await preTokenInstance.transfer(accounts[1], 100 * UNIT);
    let balance = await preTokenInstance.balanceOf(accounts[1]);
    assert.equal(balance.valueOf(), 100 * UNIT, "100 wasn't on account 1");    
  });

  it("try to send back", async () => {
    try {
      await preTokenInstance.transfer(accounts[0], 100 * UNIT, {from: accounts[1]});
      assert(false, "send back shouldn't be successful");
    } catch (error) {
      assert(error.toString().includes('invalid opcode'), error.toString()); 
    }
  });

  it("try to send to the smart contract", async () => {
    try {
      await preTokenInstance.transfer(preTokenInstance.address, 100 * UNIT, {from: accounts[1]});
      assert(false, "send to the smart contract shouldn't be successful");
    } catch (error) {
      assert(error.toString().includes('invalid opcode'), error.toString()); 
    }
  });

  it("transfer to pretoken contract", async () => {
    await tokenInstance.transfer(preTokenInstance.address, 1000 * UNIT);
    let balance = await tokenInstance.balanceOf(preTokenInstance.address);
    assert.equal(balance.valueOf(), 1000 * UNIT, "1000 wasn't in the pretoken contract");    
  });
  
  it("start buyback", async () => {
    await preTokenInstance.enableBuyBackMode(tokenInstance.address);
    let address = await preTokenInstance.backingToken();
    assert.equal(address, tokenInstance.address, "tokenReward address isn't set");
  });

  it("try to send to the smart contract", async () => {
    try {
      await preTokenInstance.transfer(preTokenInstance.address, 100 * UNIT, {from: accounts[1]});
      let balance = await tokenInstance.balanceOf(accounts[1]);
      assert.equal(balance.valueOf(), 100 * UNIT, "100 wasn't on account 1");    
    } catch (error) {
      assert(false, error.toString()); 
    }
  });

});