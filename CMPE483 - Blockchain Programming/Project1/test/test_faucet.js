// Import required artifacts and libraries
const MyGov = artifacts.require("MyGov");
const { expect } = require("chai");

// Contract test suite
contract("MyGov", (accounts) => {
  // Declare variables
  let myGovInstance;
  const tokenSupply = 20000000;
  const usdStableCoinAddress = "0xd9145CCE52D386f254917e481eB44e9943F39138";

  // Before running tests, deploy the smart contract
  before(async () => {
    myGovInstance = await MyGov.new(tokenSupply, usdStableCoinAddress);
  });

  // Test case: Ensure a user can receive tokens exactly once from the faucet
  it("should allow a user to receive tokens exactly once from the faucet", async () => {
    // Select a user account as the recipient
    const recipient = accounts[1];

    // First use of faucet should succeed
    await myGovInstance.faucet({ from: recipient });
    const balanceAfterFirstUse = await myGovInstance.balanceOf(recipient);
    expect(balanceAfterFirstUse.toNumber()).to.equal(1);

    // Second use of faucet should fail
    try {
      await myGovInstance.faucet({ from: recipient });
      // If no error is thrown, fail the test
      throw new Error(
        "Should have thrown an error for the second use of faucet"
      );
    } catch (error) {
      // Check that the error message contains the expected message
      expect(error.message).to.include(
        "You already received token from contract"
      );
    }
  });

});
