const { expect } = require("chai");


const MyGov = artifacts.require("MyGov");
const USD = artifacts.require("USD_Stable_Coin")

contract("MyGov", (accounts) => {
    let myGovInstance;
    let usdInstance;
    let owner;
    let users;
    let donators;

    let ipfshash;
    let projectdeadline;
    let paymentAmounts;
    let paymentSchedule;

    let projectId

    const tokenSupply = 20000000;
    const initialUSDSupply = 20000000

    before(async () => {

        usdInstance = await USD.new(initialUSDSupply);
        myGovInstance = await MyGov.new(tokenSupply, usdInstance.address);
        console.log("number of accounts: " + accounts.length)

        //specify excecuting accounts
        owner = accounts[0]
        users = [accounts[1], accounts[2], accounts[3]]
        donators = [
            accounts[4],
            accounts[5],
            accounts[6],
            accounts[7],
            accounts[8],
        ];

        for (i = 0; i< accounts.length; i++){
            await myGovInstance.faucet({ from: accounts[i] }) //make the users a myGov member
        }

        await usdInstance.transfer(owner, 50); //give project owner sufficient fund to submit project proposal

        //transfer myGov tokens to the owner
        for (i = 0; i< donators.length; i++){
            await myGovInstance.transfer(owner, 1, {from: donators[i]})
        }

        //parameters for project proposal
        const ONE_YEAR_IN_SECONDS = 365 * 24 * 60 * 60; // 365 days
        const currentTime = Math.floor(Date.now() / 1000); // convert from milliseconds to seconds
        ipfshash = "test_ipfshash";
        projectdeadline = currentTime + ONE_YEAR_IN_SECONDS;
        paymentAmounts = [3, 5, 10, 20];
        paymentSchedule = [
            currentTime + 50,
            currentTime + 100,
            currentTime + 200,
            currentTime + 300,
        ];

    });

    it("measures submitProjectProposal function", async () => {
        const result = await myGovInstance.submitProjectProposal(
            ipfshash,
            projectdeadline,
            paymentAmounts,
            paymentSchedule,
            { from: owner }
        );
        console.log
        projectId = result.logs[2].args.projectId;
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by submitProjectProposal function:", gasUsed);
    });

    it("measures delegateVoteTo function", async () => {
        const result = await myGovInstance.delegateVoteTo(users[1], projectId, { from: users[2] })
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by delegateVoteTo function:", gasUsed);
    });

    it("measures voteForProjectProposal function", async () => {
        const result = await myGovInstance.voteForProjectProposal(projectId, true, { from: users[0] });
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by voteForProjectProposal function:", gasUsed);
    });

    it("measures voteForProjectPayment function", async () => {
        const result = await myGovInstance.voteForProjectPayment(projectId, true, { from: users[1] });
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by voteForProjectPayment function:", gasUsed);
    });

    it("measures reserveProjectGrant function", async () => {
        const result = await myGovInstance.reserveProjectGrant(projectId, { from: owner });
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by reserveProjectGrant function:", gasUsed);
    });

    it("measures withdrawProjectPayment function", async () => {
        const result = await myGovInstance.withdrawProjectPayment(projectId, { from: owner });
        const gasUsed = result.receipt.gasUsed;
        console.log("Gas used by withdrawProjectPayment function:", gasUsed);
    });
});
