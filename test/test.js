var EnvientaToken = artifacts.require("EnvientaToken");
var EnvientaCrowdsale = artifacts.require("EnvientaCrowdsale");

contract('EnvientaCrowdsale', (accounts) => {

  UNIT = Math.pow(10, 18);
  
  let tokenInstance;
  let crowdsaleInstance;
  
  before(async () => {
    tokenInstance = await EnvientaToken.deployed();
    crowdsaleInstance = await EnvientaCrowdsale.deployed();
  });
  
  it("check initial supply", async () => {
    let balance = await tokenInstance.balanceOf(accounts[0]);
    assert.equal(balance.valueOf(), 1200000 * UNIT, "1200000 wasn't in the first account");
  });
  
  it("transfer to crowdsale contract", async () => {
    await tokenInstance.transfer(crowdsaleInstance.address, 600000 * UNIT);
    let balance = await tokenInstance.balanceOf(crowdsaleInstance.address);
    assert.equal(balance.valueOf(), 600000 * UNIT, "600000 wasn't in the crowdsale contract");    
  });

  it("start crowdsale", async () => {
    await crowdsaleInstance.start(tokenInstance.address);
    let address = await crowdsaleInstance.tokenReward();
    assert.equal(address, tokenInstance.address, "tokenReward address isn't set");
  });

  it("send 100 ETH", async () => {
    await web3.eth.sendTransaction({from: accounts[1], to: crowdsaleInstance.address, value: 100 * UNIT, gas: 100000000});
    let balance = await tokenInstance.balanceOf(accounts[1]);
    assert.equal(balance.valueOf(), 13000 * UNIT, "token reward should be 100 * 130 ENV");
  });

  it("send 1000 ETH", async () => {
    await web3.eth.sendTransaction({from: accounts[1], to: crowdsaleInstance.address, value: 1000 * UNIT, gas: 100000000});
    let balance = await tokenInstance.balanceOf(accounts[1]);
    assert.equal(balance.valueOf(), (1000 * 130 * UNIT) + (100 * 115 * UNIT), "token reward should be 1000 * 130 + 100 * 115 ENV");    
  });

  it("send 1000 ETH", async () => {
    await web3.eth.sendTransaction({from: accounts[1], to: crowdsaleInstance.address, value: 1000 * UNIT, gas: 100000000});
    let balance = await tokenInstance.balanceOf(accounts[1]);
    assert.equal(balance.valueOf(), (1000 * 130 * UNIT) + (1000 * 115 * UNIT) + (100 * 100 * UNIT), "token reward should be 1000 * 130 + 1000 * 115 + 100 * 100 ENV");
  });

  it("send 3000 ETH", async () => {
    await web3.eth.sendTransaction({from: accounts[1], to: crowdsaleInstance.address, value: 3000 * UNIT, gas: 100000000});
    let balance = await tokenInstance.balanceOf(accounts[1]);
    assert.equal(balance.valueOf(), (1000 * 130 * UNIT) + (1000 * 115 * UNIT) + (3000 * 100 * UNIT), "token reward should be 1000 * 130 + 1000 * 115 + 3000 * 100 ENV");
  });

  it("send 1000 ETH", async () => {
    await web3.eth.sendTransaction({from: accounts[1], to: crowdsaleInstance.address, value: 1000 * UNIT, gas: 100000000});
    let balance = await tokenInstance.balanceOf(accounts[1]);
    assert.equal(balance.valueOf(), (1000 * 130 * UNIT) + (1000 * 115 * UNIT) + (3000 * 100 * UNIT), "token reward should be 1000 * 130 + 1000 * 115 + 3000 * 100 ENV");
  });

  it("stop crowdsale & safeWithdrawal", async () => {
    let balanceBefore = await web3.eth.getBalance(accounts[0]);
    await crowdsaleInstance.stop();
    await crowdsaleInstance.safeWithdrawal();
    let balanceAfter = await web3.eth.getBalance(accounts[0]);
    assert(balanceAfter - balanceBefore > 4999 * UNIT, "balance should be ~5000 after crowdsale (some gas used)");
  });
  
});