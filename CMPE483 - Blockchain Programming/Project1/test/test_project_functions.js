// Importing necessary libraries and modules for testing
const { expect } = require("chai");

// Importing the smart contract artifacts for testing
const MyGov = artifacts.require("MyGov");
const USD = artifacts.require("USD_Stable_Coin");

// Declaring an array to store Ethereum accounts
let accounts = [];

// Main contract testing block
contract("MyGov", () => {
  // Declaring variables for smart contract instances and other parameters
  let myGovInstance;
  let usdInstance;
  let projectId;
  const tokenSupply = 20000000;
  const initialUSDSupply = 20000000;
  let ipfshash;
  let projectdeadline;
  let paymentAmounts;
  let paymentSchedule;

  // Before the tests run, set up necessary instances and accounts
  before(async () => {
    // Fetching Ethereum accounts using Web3
    accounts = await web3.eth.getAccounts();

    // Deploying instances of the smart contracts
    usdInstance = await USD.new(initialUSDSupply);
    myGovInstance = await MyGov.new(tokenSupply, usdInstance.address);

    // Initializing arrays of users and donators
    users = [accounts[0], accounts[1], accounts[2], accounts[3]];
    donators = [
      accounts[4],
      accounts[5],
      accounts[6],
      accounts[7],
      accounts[8],
      accounts[9],
    ];

    // Initializing user accounts and providing initial USD for transactions
    for (const user of users) {
      await myGovInstance.faucet({ from: user });
      await usdInstance.transfer(user, 20);
    }

    // Providing additional tokens to the project owner for proposal and membership
    for (donator of donators) {
      await myGovInstance.faucet({ from: donator });
      await myGovInstance.transfer(users[0], 1, { from: donator });
    }

    // Creating a project proposal and voting from half of the accounts
    const ONE_YEAR_IN_SECONDS = 365 * 24 * 60 * 60;
    const currentTime = Math.floor(Date.now() / 1000);
    ipfshash = "test_ipfshash";
    projectdeadline = currentTime + ONE_YEAR_IN_SECONDS;
    paymentAmounts = [3, 5, 10, 20];
    paymentSchedule = [
      currentTime + 50,
      currentTime + 100,
      currentTime + 200,
      currentTime + 300,
    ];

    await myGovInstance.submitProjectProposal(
      ipfshash,
      projectdeadline,
      paymentAmounts,
      paymentSchedule,
      { from: users[0] }
    );

    projectId = 0;
    i = 0;
    for (const user of users) {
      if (!(i & 1)) {
        await myGovInstance.voteForProjectProposal(projectId, true, {
          from: user,
        });
        await myGovInstance.voteForProjectPayment(projectId, true, {
          from: user,
        });
      }
      i++;
    }
  });

  // Test case: Checking if a project with the given id exists
  it("should return true if a project with the given id exists", async () => {
    const exists = await myGovInstance.projectWithIdExists(projectId);
    assert.equal(exists, true, "The project with the given id should exist");
  });

  // Test case: Checking if a project with the given id does not exist
  it("should return false if a project with the given id does not exist", async () => {
    const exists = await myGovInstance.projectWithIdExists(15);
    assert.equal(
      exists,
      false,
      "The project with the given id should not exist"
    );
  });

  // Test case: Checking the correct number of projects
  it("should return correct number of projects", async () => {
    const num_projects = await myGovInstance.getNoOfProjectProposals();
    assert.equal(
      num_projects,
      1,
      "The number of project proposals should equal 1"
    );
  });

  // Test case: Checking the correct number of funded projects
  it("should return correct number of funded projects", async () => {
    const num_projects = await myGovInstance.getNoOfFundedProjects();
    assert.equal(
      num_projects,
      0,
      "The number of funded projects should equal 0"
    );
  });

  // Test case: Checking the correct owner of a project
  it("should return correct owner", async () => {
    const owner = await myGovInstance.getProjectOwner(projectId);
    assert.equal(
      owner,
      accounts[0],
      "The project with the given id should be owned by the given account"
    );
  });

  // Test case: Checking if an error is thrown when an account votes for a project proposal second time
  it("should throw an error when account attempts to vote for a project proposal second time", async () => {
    try {
      await myGovInstance.voteForProjectProposal(projectId, true, {
        from: accounts[0],
      });
      throw new Error(
        "Should have thrown an error for the second vote of the project proposal"
      );
    } catch (error) {
      expect(error.message).to.include("You already voted");
    }
  });

  // Test case: Checking if an error is thrown when an account votes for a project payment second time
  it("should throw an error when account attempts to vote for a project payment second time", async () => {
    try {
      await myGovInstance.voteForProjectPayment(projectId, true, {
        from: accounts[0],
      });
      throw new Error(
        "Should have thrown an error for the second vote of the project payment"
      );
    } catch (error) {
      expect(error.message).to.include("You already voted");
    }
  });

  // Test case: Checking the correctness of project information
  it("should return correct project info", async () => {
    const info = await myGovInstance.getProjectInfo(projectId);
    const info_hash = info["0"];
    const info_deadline = info["1"].words[0];
    const info_payment_amounts = info["2"].map((item) => item.words[0]);
    const info_payment_schedule = info["3"].map((item) => item.words[0]);

    assert.equal(
      info_hash,
      ipfshash,
      "Returned hash should equal initial hash"
    );

    assert.deepEqual(
      info_payment_amounts,
      paymentAmounts,
      "Returned payment_amount should equal initial payment_amount"
    );
  });

  // Test case: Checking if only the project owner can reserve the project grant
  it("only project owner can reserve the project grant", async () => {
    try {
      await myGovInstance.reserveProjectGrant(projectId, {
        from: accounts[1],
      });
      throw new Error(
        "Should have thrown an error for reserving project grant trial from non-owner accounts"
      );
    } catch (error) {
      expect(error.message).to.include(
        "You need to be the project owner to reserve project grant"
      );
    }
  });

  // Test case: Checking if USD received by the project equals the first payment
  it("usd received by the project should equal to first payment", async () => {
    await myGovInstance.reserveProjectGrant(projectId, {
      from: accounts[0],
    });
    await myGovInstance.withdrawProjectPayment(projectId, {
      from: accounts[0],
    });

    let payment_amount = await myGovInstance.getUSDReceivedByProject(projectId);
    payment_amount = payment_amount.words[0];
    assert.equal(
      payment_amount,
      paymentAmounts[0],
      "usd received by the project should equal to first payment"
    );
  });
});
