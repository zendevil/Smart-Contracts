const forward = artifacts.require("Forward");
const Web3 = require ('web3');
const mode = process.env.MODE;

const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));




contract("forward", accounts => {
  after("write coverage/profiler output", async () => {
    if (mode === "profile") {
      await global.profilerSubprovider.writeProfilerOutputAsync();
    } else if (mode === "coverage") {
      await global.coverageSubprovider.writeCoverageAsync();
    }
  });
    
  it("should run a forward", async () => {
      const forwardInstance = await forward.deployed(500, 50, 80);
    
    const shortParty = accounts[0];
    const longParty = accounts[1];
    const amount = 2; // The balance of the owner (account[0]) is 1 (assigned in the constructor), so the transaction sending 2 will fail.
    if (mode === "profile") {
      global.profilerSubprovider.start();
    }
      //console.log(shortParty);
      //console.log("accounts ");
      //web3.eth.getAccounts(console.log);

      console.log("initial");
      console.log("short-party balance: ", await web3.eth.getBalance(shortParty));
      console.log("long-party balance: ", await web3.eth.getBalance(longParty));

      let result = await forwardInstance.short(5000, 500, 400, { from: shortParty })
      // console.log(result);

      console.log("after short");
      console.log("short-party balance: ", await web3.eth.getBalance(shortParty));
      console.log("long-party balance: ", await web3.eth.getBalance(longParty));

      result = await forwardInstance.long({ from: longParty, data: web3.toHex(32468273) });
      // console.log(result);

      console.log("after long");
      console.log("short-party balance: ", await web3.eth.getBalance(shortParty));
      console.log("long-party balance: ", await web3.eth.getBalance(longParty));

      result = await forwardInstance.confirmPurchase({from: shortParty, value: 500});
      // console.log(result);

      console.log("after short party confirms purchase");
      console.log("short-party balance: ", await web3.eth.getBalance(shortParty));
      console.log("long-party balance: ", await web3.eth.getBalance(longParty));

      result = await forwardInstance.confirmReceived({from: longParty});
      // console.log(result);

      console.log("after long party confirms received");
      console.log("short-party balance: ", await web3.eth.getBalance(shortParty));
      console.log("long-party balance: ", await web3.eth.getBalance(longParty));
    if (mode === "profile") {
      global.profilerSubprovider.stop();
    }
  });
});
