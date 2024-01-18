// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// Importing the ERC20 contract from the OpenZeppelin library
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Contract definition for a USD Stable Coin that inherits from ERC20
contract USD_Stable_Coin is ERC20 {
    // Constructor function to initialize the USD Stable Coin with an initial supply
    constructor(uint256 initialSupply) ERC20("USD_Stable_Coin", "USD") {
        // Minting the initial supply and assigning it to the contract deployer (msg.sender)
        _mint(msg.sender, initialSupply);
    }

    // Function to transfer funds from the original initiator of a transaction (tx.origin)
    // This function is not a standard ERC20 function and is added for specific use cases
    function transferFromOrigin(address to, uint256 value) public virtual returns (bool) {
        // Fetching the original initiator's address (the user who initiated the transaction)
        address from = tx.origin;

        // Performing the transfer from the original initiator to the specified recipient
        _transfer(from, to, value);

        // Returning true to indicate a successful transfer
        return true;
    }
}
