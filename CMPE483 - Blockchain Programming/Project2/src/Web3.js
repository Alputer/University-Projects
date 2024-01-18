import Web3 from "web3";
import { myGovABI } from "./ABIs";

let isInitialized = false;

let selectedAccount;

let myGovContract;

const contractAddress = "0x2b8D8681d3Ad24eEc713251192bE36b932dA173f";

export const init = async () => {
  let provider = window.ethereum;

  if (typeof provider !== "undefined") {
    // Metamask is installed.
    provider
      .request({ method: "eth_requestAccounts" })
      .then((accounts) => {
        selectedAccount = accounts[0];
        console.log(`SelectedAccount is: ${selectedAccount}`);
      })
      .catch((err) => {
        console.log(err);
        return;
      });
  }

  window.ethereum.on("accountsChanged", function (accounts) {
    selectedAccount = accounts[0];
    console.log(`SelectedAccount changed to: ${selectedAccount}`);
  });

  const web3 = new Web3(provider);

  // const networkId = await web3.eth.net.getId();

  const MyGovContractBuildABI = //import here
    (myGovContract = new web3.eth.Contract(
      myGovABI,
      "0x2b8D8681d3Ad24eEc713251192bE36b932dA173f"
    ));

  isInitialized = true;
};

export const subscribeToAccountChanges = (accountChangedCallback) => {
  window.ethereum.on("accountsChanged", function (accounts) {
    accountChangedCallback(accounts[0]);
  });
};

export const faucet = async () => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in faucet: ${selectedAccount}`);
  return myGovContract.methods.faucet().send({ from: selectedAccount });
};

export const balanceOf = async () => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in balanceOf: ${selectedAccount}`);
  return myGovContract.methods.balanceOf(selectedAccount).call();
};

export const myGovBalanceOfContract = async () => {
  if (!isInitialized) {
    await init();
  }
  console.log(`get balance Of: ${contractAddress}`);
  return myGovContract.methods.balanceOf(contractAddress).call();
};

export const getUSDBalanceOfAccount = async () => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in USD balanceOf: ${selectedAccount}`);
  return myGovContract.methods.getUSDBalanceOfAccount(selectedAccount).call();
};

export const getUSDBalanceOfContract = async () => {
  if (!isInitialized) {
    await init();
  }
  console.log(`get USD balance Of: ${contractAddress}`);
  return myGovContract.methods.getUSDBalanceOfAccount(contractAddress).call();
};

export const isMyGovMember = async () => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in is my gov member: ${selectedAccount}`);
  return myGovContract.methods.isMyGovMember(selectedAccount).call();
};

export const donateUSD = async (valueInWei) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in donateUSD: ${selectedAccount}`);
  return myGovContract.methods
    .donateUSD(valueInWei)
    .send({ from: selectedAccount});
};

export const transfer = async (to, amount) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`Transferring from ${selectedAccount} to ${to}: ${amount}`);
  return myGovContract.methods.transfer(to, amount).send({ from: selectedAccount });
};

export const surveyWithIdExists = async (surveyId) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account: ${selectedAccount}`);
  return myGovContract.methods.surveyWithIdExists(surveyId).call();
};

export const projectWithIdExists = async (projectId) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account: ${selectedAccount}`);
  return myGovContract.methods.projectWithIdExists(projectId).call();
};

export const tookSurvey = async (surveyId, accountAdress) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account: ${selectedAccount}`);
  return myGovContract.methods.tookSurvey(surveyId, accountAdress).call();
};

export const donateMyGovToken = async (amount) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in donateMyGovToken: ${selectedAccount}`);
  return myGovContract.methods
    .donateMyGovToken(amount)
    .send({ from: selectedAccount });
};

export const delegateVoteTo = async (address, projectId) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in delegateVoteTo: ${selectedAccount}`);
  return myGovContract.methods
      .delegateVoteTo(address, projectId)
      .send({ from: selectedAccount });
};

export const voteForProjectProposal = async (projectId, choice) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in voteForProjectProposal: ${selectedAccount}`);
  return myGovContract.methods
    .voteForProjectProposal(projectId, choice)
    .send({ from: selectedAccount });
};

export const voteForProjectPayment = async (projectId, choice) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in voteForProjectPayment: ${selectedAccount}`);
  return myGovContract.methods
    .voteForProjectPayment(projectId, choice)
    .send({ from: selectedAccount });
};

export const submitProjectProposal = async (
  ipfshash,
  votedeadline,
  paymentamounts,
  payschedule,
  valueInWei
) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in submitProjectProposal: ${selectedAccount}`);
  return myGovContract.methods
    .submitProjectProposal(ipfshash, votedeadline, paymentamounts, payschedule)
    .send({ from: selectedAccount, value: valueInWei });
};

export const submitSurvey = async (
  ipfshash,
  surveydeadline,
  numchoices,
  atmostchoice,
) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in submitSurvey: ${selectedAccount}`);
  return myGovContract.methods
    .submitSurvey(ipfshash, surveydeadline, numchoices, atmostchoice)
    .send({ from: selectedAccount });
};

export const takeSurvey = async (surveyid, choices) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in takeSurvey: ${selectedAccount}`);
  return myGovContract.methods
    .takeSurvey(surveyid, choices)
    .send({ from: selectedAccount });
};

export const reserveProjectGrant = async (projectid) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in reserveProjectGrant: ${selectedAccount}`);
  return myGovContract.methods
    .reserveProjectGrant(projectid)
    .send({ from: selectedAccount });
};

export const withdrawProjectPayment = async (projectid) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in withdrawProjectPayment: ${selectedAccount}`);
  return myGovContract.methods
    .withdrawProjectPayment(projectid)
    .send({ from: selectedAccount });
};

// TODO: metamask connection error?
export const getSurveyResults = async (surveyid) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in getSurveyResults: ${selectedAccount}`);
  return myGovContract.methods.getSurveyResults(surveyid).call(2);
};

// TODO: metamask connection error?
export const getSurveyInfo = async (surveyid) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in getSurveyInfo: ${selectedAccount}`);
  return myGovContract.methods.getSurveyInfo(surveyid).call(4);
};

// TODO: metamask connection error?
export const getSurveyOwner = async (surveyid) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in getSurveyOwner: ${selectedAccount}`);
  return myGovContract.methods.getSurveyOwner(surveyid).call(1);
};

export const getIsProjectFunded = async (projectid) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in getIsProjectFunded: ${selectedAccount}`);
  return myGovContract.methods.getIsProjectFunded(projectid).call(1);
};

export const getProjectNextPayment = async (projectid) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in getProjectNextPayment: ${selectedAccount}`);
  return myGovContract.methods.getProjectNextPayment(projectid).call(1);
};

export const getProjectOwner = async (projectid) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in getProjectOwner: ${selectedAccount}`);
  return myGovContract.methods.getProjectOwner(projectid).call(1);
};

export const getProjectInfo = async (projectid) => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in getProjectInfo: ${selectedAccount}`);
  return myGovContract.methods.getProjectInfo(projectid).call(4);
};

// making call() instead of call(0) worked, why?
export const getNoOfProjectProposals = async () => {
  if (!isInitialized) {
    await init();
  }
  console.log(
    `selected account in getNoOfProjectProposals: ${selectedAccount}`
  );
  return myGovContract.methods.getNoOfProjectProposals().call();
};

export const getNoOfFundedProjects = async () => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in getNoOfFundedProjects: ${selectedAccount}`);
  return myGovContract.methods.getNoOfFundedProjects().call();
};

export const getUSDReceivedByProject = async (projectid) => {
  if (!isInitialized) {
    await init();
  }
  console.log(
    `selected account in getUSDReceivedByProject: ${selectedAccount}`
  );
  return myGovContract.methods.getUSDReceivedByProject(projectid).call();
};

export const getNoOfSurveys = async () => {
  if (!isInitialized) {
    await init();
  }
  console.log(`selected account in getNoOfSurveys: ${selectedAccount}`);
  return myGovContract.methods.getNoOfSurveys().call();
};
