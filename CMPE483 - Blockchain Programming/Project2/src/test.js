const Web3 = require("web3");
const web3 = new Web3("https://rpc.bloxberg.org/");

web3.eth.getCode(
  "0x9D8AA7AdD508ce3A3D5399178a5c01B3A5a39674",
  (error, code) => {
    if (code === "0x") {
      console.log("Contract not found at the specified address.");
    } else {
      console.log("Contract deployed successfully.");
    }
  }
);
