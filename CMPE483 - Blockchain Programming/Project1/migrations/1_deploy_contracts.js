import Web3 from "web3";
const USD_StableBaseCoinContract = artifacts.require("USD_Stable_Coin");
const MyGovContract = artifacts.require("MyGov");

module.exports = async function (deployer) {
  if (typeof window.ethereum !== "undefined") {
    // MetaMask is installed
  } else {
    // MetaMask is not installed
    alert("Please install MetaMask to use this feature");
  }

  ethereum
    .request({ method: "eth_requestAccounts" })
    .then((accounts) => {
      const currentAccount = accounts[0];
      console.log("Current account:", currentAccount);

      // Print the address
      console.log("Current account address:", currentAccount);
    })
    .catch((error) => {
      console.error(error);
    });

  const USD_StableBaseCoinContract_instance = await deployer.deploy(
    USD_StableBaseCoinContract,
    1000000
  );
  await deployer.deploy(
    MyGovContract,
    20000000,
    USD_StableBaseCoinContract_instance.address
  );
};
