const { expect } = require("chai");


const MyGov = artifacts.require("MyGov");
const USD = artifacts.require("USD_Stable_Coin")

contract("MyGov", (accounts) => {
    let myGovInstance;
    let usdInstance;
    let owner;
    let user;
    let donators;

    let surveyId;
    let choices;

    let ipfshash;
    let surveydeadline;
    let numchoices;
    let atmostchoice;

    const tokenSupply = 20000000;
    const initialUSDSupply = 20000000


    before(async () => {

        usdInstance = await USD.new(initialUSDSupply);
        myGovInstance = await MyGov.new(tokenSupply, usdInstance.address);
        console.log("number of accounts: " + accounts.length)

        //specify excecuting accounts for survey
        owner = accounts[0]
        user = accounts[1]
        donators = [accounts[2], accounts[3]]
    });

    it("measures faucet function", async () => {
        const result = await myGovInstance.faucet({ from: owner });
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by faucet function:", gasUsed);
    });

    it("measures faucet function average (n=9)", async () => {
        let gasUsed = 0;
        for (i = 1; i < accounts.length; i++){
            const result = await myGovInstance.faucet({ from: accounts[i] });
            gasUsed += result.receipt.gasUsed;
        }
        console.log("average gas used by faucet function:", gasUsed/(accounts.length-1));
    });

    it("measures usdTransfer function", async () => {
        const result = await usdInstance.transfer(owner, 5) //get sufficient USD for survey submission
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by usdTransfer function:", gasUsed);
    });

    it("measures transfer function", async () => {
        const result = await myGovInstance.transfer(owner, 1, {from: donators[0]})
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by transfer function:", gasUsed);
    });

    it("measures donateMyGovToken function", async () => {
        const result = await myGovInstance.donateMyGovToken(1, {from: donators[1]})
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by donateMyGovToken function:", gasUsed);
    });

    it("measures submitSurvey function", async () => {
        const ONE_YEAR_IN_SECONDS = 365 * 24 * 60 * 60; // 365 days
        const currentTime = Math.floor(Date.now() / 1000); // convert from milliseconds to seconds
        ipfshash = "test_ipfshash";
        surveydeadline = currentTime + ONE_YEAR_IN_SECONDS;
        numchoices = 3;
        atmostchoice = 2;
        const result = await myGovInstance.submitSurvey(ipfshash, surveydeadline, numchoices,  atmostchoice, { from: owner })
        surveyId = result.logs[2].args.surveyId;
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by submitSurvey function:", gasUsed);
    });

    it("measures takeSurvey function", async () => {
        choices = [0,1]
        const result = await myGovInstance.takeSurvey(surveyId, choices, { from: user})
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by takeSurvey function:", gasUsed);
    });

    it("measures takeSurvey function average (n=6)", async () => {
        choices = [0,1]
        let gasUsed = 0;
        for (i = 4; i < accounts.length; i++){
            const result = await myGovInstance.takeSurvey(surveyId, choices, { from: accounts[i]})
            gasUsed += result.receipt.gasUsed;
        }
        console.log("Gas used by takeSurvey function:", gasUsed/(accounts.length-4));
    });
});
