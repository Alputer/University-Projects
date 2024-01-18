// Import necessary modules and libraries for testing
const { expect } = require("chai");

// Import the smart contract artifacts
const MyGov = artifacts.require("MyGov");
const USD = artifacts.require("USD_Stable_Coin");

// Define the main test contract
contract("MyGov", (accounts) => {
  let myGovInstance;
  let usdInstance;
  let users;
  let donators;

  let surveyId;
  let choices;

  let ipfshash;
  let surveydeadline;
  let numchoices;
  let atmostchoice;

  // Define constants for token and initial USD supply
  const tokenSupply = 20000000;
  const initialUSDSupply = 20000000;

  // Setup initial conditions before running the tests
  before(async () => {
    // Deploy instances of MyGov and USD contracts
    usdInstance = await USD.new(initialUSDSupply);
    myGovInstance = await MyGov.new(tokenSupply, usdInstance.address);

    // Specify executing accounts for users and donators
    users = [accounts[0], accounts[1], accounts[2], accounts[3]];
    donators = [accounts[4], accounts[5], accounts[6], accounts[7]];

    // Distribute initial tokens and USD to users
    for (i = 0; i < users.length; i++) {
      await myGovInstance.faucet({ from: users[i] });
      await usdInstance.transfer(users[i], 5);
    }

    // Distribute additional tokens to users for survey participation
    for (i = 0; i < donators.length - 1; i++) {
      await myGovInstance.faucet({ from: donators[i] });
      await myGovInstance.transfer(users[i], 1, { from: donators[i] });
    }

    // Create a survey and make the first user the owner
    const ONE_YEAR_IN_SECONDS = 365 * 24 * 60 * 60;
    const currentTime = Math.floor(Date.now() / 1000);
    ipfshash = "test_ipfshash";
    surveydeadline = currentTime + ONE_YEAR_IN_SECONDS;
    numchoices = 3;
    atmostchoice = 2;
    const result = await myGovInstance.submitSurvey(
      ipfshash,
      surveydeadline,
      numchoices,
      atmostchoice,
      { from: users[0] }
    );

    // Take the survey from every user account, except the first one
    surveyId = result.logs[2].args.surveyId;
    choices = [0, 1];
    for (i = 1; i < users.length; i++) {
      await myGovInstance.takeSurvey(surveyId, choices, { from: users[i] });
    }
  });

  // Test case: check if a survey with a given id exists
  it("should return true if a survey with the given id exists", async () => {
    const exists = await myGovInstance.surveyWithIdExists(surveyId);
    assert.equal(exists, true, "The survey with the given id should exist");
  });

  // Test case: check if an account took the survey
  it("should return true if the account took the survey", async () => {
    const took = await myGovInstance.tookSurvey(surveyId, users[1]);
    assert.equal(
      took,
      true,
      "The survey with the given id should have been taken by the given account"
    );
  });

  // Test case: check for an error when an account attempts to take the survey a second time
  it("should throw an error when account attempts to take survey a second time", async () => {
    try {
      await myGovInstance.takeSurvey(surveyId, choices, { from: users[1] });
      throw new Error(
        "Should have thrown an error for the second take of the survey"
      );
    } catch (error) {
      expect(error.message).to.include("You already took the survey");
    }
  });

  // Test case: check if the survey results are correct
  it("should return correct survey results", async () => {
    const result = await myGovInstance.getSurveyResults(surveyId);
    const correct_numTaken = users.length - 1;
    const correct_results = [users.length - 1, users.length - 1, 0];
    const res = [
      result[1][0].words[0],
      result[1][1].words[0],
      result[1][2].words[0],
    ];
    assert.equal(
      result[0],
      correct_numTaken,
      "The number of accounts should equal to " + correct_numTaken
    );
    assert.deepEqual(
      res,
      correct_results,
      "The results should be " + correct_results
    );
  });

  // Test case: check if the survey info is correct
  it("should return correct survey info", async () => {
    const info = await myGovInstance.getSurveyInfo(surveyId);
    const info_hash = info["0"];
    const info_deadline = info["1"].words[0];
    const info_numchoices = info["2"].words[0];
    const info_mostchoice = info["3"].words[0];
    assert.equal(
      info_hash,
      ipfshash,
      "returned hash should equal initial hash"
    );
    assert.equal(
      info_numchoices,
      numchoices,
      "returned num of choices should equal initial num of choices"
    );
    assert.equal(
      info_mostchoice,
      atmostchoice,
      "returned atmostchoice should equal initial atmostchoice"
    );
  });

  // Test case: check if the survey owner is correct
  it("should return correct owner", async () => {
    const owner = await myGovInstance.getSurveyOwner(surveyId);
    assert.equal(
      owner,
      users[0],
      "The survey with the given id should be owned by the given account"
    );
  });

  // Test case: check if the number of surveys is correct
  it("should return correct number of surveys", async () => {
    const num_surveys = await myGovInstance.getNoOfSurveys();
    assert.equal(num_surveys, 1, "The number of surveys should equal 1");
  });
});
