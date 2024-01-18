// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// Import OpenZeppelin ERC20 implementation
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// Import custom USD stable coin contract
import "./USD.sol";

// MyGov smart contract inherits from ERC20
contract MyGov is ERC20 {

    // Struct to represent a survey
    struct Survey {
        uint id; // id of the survey, index of the survey in the surveys array
        string ipfsHash; // ipfs hash of the survey
        uint deadline; // Deadline of the survey
        uint numChoices; // Number of choices in the survey
        uint atMostChoice; // Number of choices the user is allowed to choose at most
        uint[] results; // Total number of choices given for specific option
        address owner; // Owner of the survey
        mapping(address => uint[]) choices; // Mapping of user addresses and their choices
        uint numTaken; // How many times users took the survey
    }

    // Struct to represent a project
    struct Project { 
        uint id; // id of the project, index of the project in the projects array
        string ipfsHash; // ipfs hash of the project
        uint voteDeadline; // Deadline of the voting phase
        uint[] paymentAmounts; // Payment amounts for each payment date
        uint[] paymentSchedule; // Payment schedule
        uint[] yesVouteCountsOfPayments; // Number of 'Yes' votes for each payment
        uint currPaymentIndex; // Index of the next payment
        uint yesVoteCount; // Total 'Yes' votes for the project proposal
        address owner; // Owner of the project
        bool isReserved; // Flag indicating if project grant is reserved
        mapping(address => Voter) voters; // Mapping of users (voters) and their votes
        uint received_USD_amount; // Total USD amount received by the project
        bool allPaymentWithdrawn; // Flag indicating if all payments are withdrawn
    }

    // Struct to represent a voter
    struct Voter {
        bool didDelegate; // Whether voter delegated their voting right
        address delegatingTo; // The address the voter delegates to if exists
        bool didVote; // Whether voter voted or not
        mapping(uint => bool) didVotePayments; // Whether the voter has voted for a payment or not
        mapping(uint => bool) paymentVotes; // Votes for each payment
        uint voteMultiplier; // If someone delegates their vote right, power multiplier
        bool choice; // 0 for 'No', 1 for 'Yes' representing the vote for project proposal.
    }

    // Constants for costs
    uint256 constant SURVEY_SUBMISSION_MYGOV_TOKEN_COST = 2;
    uint256 constant SURVEY_SUBMISSION_USD_STABLE_COIN_COST = 5;
    uint256 constant PROJECT_PROPOSAL_MYGOV_TOKEN_COST = 5;
    uint256 constant PROJECT_PROPOSAL_USD_STABLE_COIN_COST = 50;

    // Variables
    uint256 token_supply;
    USD_Stable_Coin public USD_BaseCoinContract;
    uint256 myGovMemberCount = 0;
    uint256 reservedUSD_StableCoins = 0;

    mapping(address => bool) usedFaucet;

    // Arrays to store surveys and projects
    Survey[] public surveys;  
    Project[] public projects;  

    // Events
    event SurveySubmitted(uint surveyId, address account);
    event ProjectSubmitted(uint projectId, address account);

// Constructor function for initializing the MyGov contract
constructor(uint tokensupply, address usdStableCoinAddress) ERC20("MyGov", "MG") {
    require(tokensupply == 20000000, "MyGov token supply must be equal to 20 million");
    token_supply = tokensupply; // Set the total token supply
    _mint(address(this), tokensupply); // Mint tokens to the contract's address
    USD_BaseCoinContract = USD_Stable_Coin(usdStableCoinAddress); // Initialize the USD stable coin contract
}

// Function to donate USD stable coins to the contract
function donateUSD(uint amount) public {
    USD_BaseCoinContract.transferFromOrigin(address(this), amount); // Transfer USD stable coins to the contract
}

// Function to donate MyGov tokens to the contract
function donateMyGovToken(uint amount) public {
    transfer(address(this), amount); // Transfer MyGov tokens to the contract
    if (!isMyGovMember(msg.sender)) {
        myGovMemberCount--; // Decrement MyGov member count if the sender is not a MyGov member
    }
}

// Function to get the USD balance of a specific account
function getUSDBalanceOfAccount(address _account) public view returns (uint256) {
    return USD_BaseCoinContract.balanceOf(_account); // Retrieve the USD balance of the specified account
}

// Function to check if an address is a MyGov member based on their MyGov token balance
function isMyGovMember(address _address) public view returns(bool) {
    return balanceOf(_address) > 0; // Check if the specified address holds MyGov tokens
}

// Function to check if a survey with the given ID exists
function surveyWithIdExists(uint survey_id) public view returns(bool) {
    return surveys.length > survey_id; // Return true if the survey ID is within the range of existing surveys
}

// Function to check if a project with the given ID exists
function projectWithIdExists(uint project_id) public view returns(bool) {
    return projects.length > project_id; // Return true if the project ID is within the range of existing projects
}

// Function to check if an account has taken a survey with the given ID
// Returns true if the account has taken the survey, otherwise false
function tookSurvey(uint survey_id, address _account) public view returns(bool) {
    require(surveyWithIdExists(survey_id), "Survey with id does not exist");
    return surveys[survey_id].choices[_account].length > 0; // Check if the account's choices for the survey exist
}

// Function to submit a new survey
// Returns the ID of the newly submitted survey
function submitSurvey(string memory ipfshash, uint surveydeadline, uint numchoices, uint atmostchoice) public returns (uint surveyid) {
    require(isMyGovMember(msg.sender), "You should be a MyGov member to submit a survey"); // Only members can submit a survey
    require(balanceOf(msg.sender) >= SURVEY_SUBMISSION_MYGOV_TOKEN_COST, "Not sufficient MyGov token to submit survey"); // Check MyGov token balance
    require(getUSDBalanceOfAccount(msg.sender) >= SURVEY_SUBMISSION_USD_STABLE_COIN_COST, "Not sufficient USD Stable coin to submit survey"); // Check USD balance

    donateMyGovToken(SURVEY_SUBMISSION_MYGOV_TOKEN_COST); // Deduct MyGov tokens
    donateUSD(SURVEY_SUBMISSION_USD_STABLE_COIN_COST); // Deduct USD Stable Coins

    // Create a new survey and initialize its properties
    Survey storage newSurvey = surveys.push();
    newSurvey.id = surveys.length - 1;
    newSurvey.ipfsHash = ipfshash;
    newSurvey.deadline = surveydeadline;
    newSurvey.numChoices = numchoices;
    newSurvey.atMostChoice = atmostchoice;
    newSurvey.results = new uint[](numchoices);
    newSurvey.owner = msg.sender;
    newSurvey.numTaken = 0;

    // Decrement MyGov member count if the sender is not a MyGov member
    if(!isMyGovMember(msg.sender)){
        myGovMemberCount--;
    }

    // Emit an event to notify that a survey has been submitted
    emit SurveySubmitted(newSurvey.id, msg.sender);
    return newSurvey.id; // Return the ID of the newly created survey
}

// Function for a user to take a survey and record their choices
function takeSurvey(uint surveyid, uint[] memory choices) public {
    require(surveyWithIdExists(surveyid), "Survey with id does not exist"); // Check if the survey exists
    require(isMyGovMember(msg.sender), "You should be a MyGov member to take a survey"); // Only members can take a survey
    require(!tookSurvey(surveyid, msg.sender), "You already took the survey"); // Check if the user already took the survey
    require(choices.length <= surveys[surveyid].atMostChoice, "You selected more choices than allowed"); // Check if the number of choices is within the allowed limit
    require(surveys[surveyid].deadline > block.timestamp, "Deadline passed"); // Check if the survey deadline has not passed

    // Validate each choice against the number of choices in the survey
    for(uint i = 0; i < choices.length; i++) {
        require(choices[i] < surveys[surveyid].numChoices, "Invalid choice number supplied");
    }

    // Record the choices and update survey results
    for(uint i = 0; i < choices.length; i++) {
        surveys[surveyid].results[choices[i]]++;
    }
    surveys[surveyid].choices[msg.sender] = choices;
    surveys[surveyid].numTaken++;
}

// Function to get the results of a survey, including the number of participants and their choices
function getSurveyResults(uint surveyid) public view returns(uint numtaken, uint [] memory results) {
    require(surveyWithIdExists(surveyid), "Survey with id does not exist"); // Check if the survey exists
    return (surveys[surveyid].numTaken, surveys[surveyid].results); // Return the number of participants and their choices
}

// Function to get information about a survey, including its IPFS hash, deadline, number of choices, and the maximum choices allowed
function getSurveyInfo(uint surveyid) public view returns(string memory ipfshash, uint surveydeadline, uint numchoices, uint atmostchoice) {
    require(surveyWithIdExists(surveyid), "Survey with id does not exist"); // Check if the survey exists
    return (
        surveys[surveyid].ipfsHash,
        surveys[surveyid].deadline,
        surveys[surveyid].numChoices,
        surveys[surveyid].atMostChoice
    ); // Return survey information
}

// Function to get the owner of a survey
function getSurveyOwner(uint surveyid) public view returns(address surveyowner) {
    require(surveyWithIdExists(surveyid), "Survey with id does not exist"); // Check if the survey exists
    return surveys[surveyid].owner; // Return the owner of the survey
}

// Function to get the total number of surveys
function getNoOfSurveys() public view returns(uint numsurveys) {
    return surveys.length; // Return the total number of surveys
}


    // Function to delegate voting power to another member for a specific project
function delegateVoteTo(address memberaddr, uint projectid) public {
    require(projectWithIdExists(projectid), "Project with id does not exist"); // Check if the project exists
    require(isMyGovMember(msg.sender), "You should be a member to be able to delegate vote"); // Check if the sender is a MyGov member
    require(memberaddr != msg.sender, "You cannot delegate to yourself"); // Ensure the delegation is not to the sender itself
    require(!projects[projectid].voters[msg.sender].didVote, "You already voted"); // Ensure the sender has not already voted
    require(!projects[projectid].voters[msg.sender].didDelegate, "You already delegated your vote"); // Ensure the sender has not already delegated their vote

    // Update sender's delegation information
    projects[projectid].voters[msg.sender].didDelegate = true;
    projects[projectid].voters[msg.sender].delegatingTo = memberaddr;
    
    // Set initial vote multiplier for the sender if not already set
    if(projects[projectid].voters[msg.sender].voteMultiplier == 0 ) {
        projects[projectid].voters[msg.sender].voteMultiplier = 1;
    }

    // Traverse the delegation graph to ensure there is no loop
    address ptr = projects[projectid].voters[msg.sender].delegatingTo;
    while(projects[projectid].voters[ptr].delegatingTo != address(0)) {
        ptr = projects[projectid].voters[ptr].delegatingTo;
        require(ptr != msg.sender, "There is a loop in the delegation graph!");
    }

    // Set initial vote multiplier for the delegate if not already set
    if(projects[projectid].voters[ptr].voteMultiplier == 0 ) {
        projects[projectid].voters[ptr].voteMultiplier = 1;
    }

    // Update the sender's delegation to the final delegate address
    projects[projectid].voters[msg.sender].delegatingTo = ptr;
    
    // Update the yesVoteCount based on the delegate's previous votes
    if(projects[projectid].voters[ptr].didVote) {
        if(projects[projectid].voters[ptr].choice) {
            projects[projectid].yesVoteCount += projects[projectid].voters[msg.sender].voteMultiplier;
        }
    } else {
        // If the delegate has not voted yet, update their voteMultiplier
        projects[projectid].voters[ptr].voteMultiplier += projects[projectid].voters[msg.sender].voteMultiplier;
    }
}


// Function to vote for or against a project proposal
function voteForProjectProposal(uint projectid, bool choice) public {
    require(projectWithIdExists(projectid), "Project with id does not exist"); // Check if the project exists
    require(isMyGovMember(msg.sender), "You should be a MyGov member to vote for project proposal"); // Check if the sender is a MyGov member
    require(projects[projectid].voteDeadline > block.timestamp, "Deadline passed"); // Check if the voting deadline for the project proposal has not passed
    require(!projects[projectid].voters[msg.sender].didVote, "You already voted"); // Ensure the sender has not already voted

    // Set initial vote multiplier for the sender if not already set
    if(projects[projectid].voters[msg.sender].voteMultiplier == 0) {
        projects[projectid].voters[msg.sender].voteMultiplier = 1;
    }

    // Update sender's vote information for the project proposal
    projects[projectid].voters[msg.sender].didVote = true;
    projects[projectid].voters[msg.sender].choice = choice; // true --> YES, false --> NO 

    // Update yesVoteCount based on the sender's vote choice
    if(choice) {
        projects[projectid].yesVoteCount += projects[projectid].voters[msg.sender].voteMultiplier;
    }
}

// Function to vote for or against a specific payment of a funded project
function voteForProjectPayment(uint projectid, bool choice) public {
    require(projectWithIdExists(projectid), "Project with id does not exist"); // Check if the project exists
    require(isMyGovMember(msg.sender), "You should be a MyGov member to vote for project payment"); // Check if the sender is a MyGov member
    require(projects[projectid].paymentSchedule[projects[projectid].currPaymentIndex] > block.timestamp, "Deadline passed"); // Check if the payment deadline has not passed
    require(!projects[projectid].voters[msg.sender].didVotePayments[projects[projectid].currPaymentIndex], "You already voted"); // Ensure the sender has not already voted for this payment

    // Set initial vote multiplier for the sender if not already set
    if(projects[projectid].voters[msg.sender].voteMultiplier == 0) {
        projects[projectid].voters[msg.sender].voteMultiplier = 1;
    }

    // Update sender's vote information for the specific payment
    projects[projectid].voters[msg.sender].didVotePayments[projects[projectid].currPaymentIndex] = true;
    projects[projectid].voters[msg.sender].paymentVotes[projects[projectid].currPaymentIndex] = choice;

    // Update yesVouteCountsOfPayments based on the sender's vote choice
    if(choice) {
        projects[projectid].yesVouteCountsOfPayments[projects[projectid].currPaymentIndex] += projects[projectid].voters[msg.sender].voteMultiplier;
    }
}

    // Function to submit a project proposal
function submitProjectProposal(string memory ipfshash, uint votedeadline, uint [] memory paymentamounts, uint [] memory payschedule) public returns (uint projectid) {
    require(isMyGovMember(msg.sender), "You should be a MyGov member to propose a project"); // Only members can propose a project
    require(balanceOf(msg.sender) >= PROJECT_PROPOSAL_MYGOV_TOKEN_COST, "Not sufficient MyGov token to propose a project" ); // Check if the sender has enough MyGov tokens
    require(getUSDBalanceOfAccount(msg.sender) >= PROJECT_PROPOSAL_USD_STABLE_COIN_COST, "Not sufficient USD Stable coin to propose a project" ); // Check if the sender has enough USD Stable Coins

    donateMyGovToken(PROJECT_PROPOSAL_MYGOV_TOKEN_COST); // Deduct the MyGov tokens for the proposal
    donateUSD(PROJECT_PROPOSAL_USD_STABLE_COIN_COST); // Deduct the USD Stable Coins for the proposal

    Project storage newProject = projects.push(); // Create a new project and get its reference
    uint new_project_id = projects.length - 1; // Get the new project's ID
    newProject.id = new_project_id;
    projects[new_project_id].ipfsHash = ipfshash;
    projects[new_project_id].voteDeadline = votedeadline;
    projects[new_project_id].paymentAmounts = paymentamounts;
    projects[new_project_id].paymentSchedule = payschedule;
    projects[new_project_id].yesVouteCountsOfPayments = new uint[](payschedule.length);
    projects[new_project_id].owner = msg.sender;
    projects[new_project_id].currPaymentIndex = 0;
    projects[new_project_id].yesVoteCount = 0;
    projects[new_project_id].isReserved = false;
    projects[new_project_id].received_USD_amount = 0;
    projects[new_project_id].allPaymentWithdrawn = false;

    if(!isMyGovMember(msg.sender)){
        myGovMemberCount--; // Decrease the member count if the sender is not already a MyGov member
    }

    emit ProjectSubmitted(new_project_id, msg.sender); // Emit an event for the submitted project
    return new_project_id; // Return the ID of the submitted project
}

// Function to reserve a project grant
function reserveProjectGrant(uint projectid) public {
    require(projectWithIdExists(projectid), "Project with id does not exist"); // Check if the project exists
    require(projects[projectid].owner == msg.sender, "You need to be the project owner to reserve project grant"); // Check if the sender is the owner of the project
    require(!projects[projectid].isReserved, "You already reserved the project grant, project grant can be reserved only once"); // Check if the project grant is not already reserved
    require(projects[projectid].yesVoteCount * 10 >= myGovMemberCount, "There is not enough yes votes for the current project grant"); // Check if there are enough yes votes for the project grant
    require(projects[projectid].voteDeadline > block.timestamp, "Deadline passed"); // Check if the vote deadline has not passed

    uint total_payment = 0;
    for(uint i = 0; i < projects[projectid].paymentAmounts.length; i++){
        total_payment += projects[projectid].paymentAmounts[i]; // Calculate the total payment amount for the project
    }
    require(getUSDBalanceOfAccount(address(this)) - reservedUSD_StableCoins >= total_payment, "There is not enough USD Stable Coin in the contract to reserve the project grant"); // Check if there is enough reserve amount for the payment

    reservedUSD_StableCoins += total_payment; // Reserve the project grant amount in USD Stable Coins
    projects[projectid].isReserved = true; // Mark the project grant as reserved
}


// Function to withdraw the payment for the current project
function withdrawProjectPayment(uint projectid) public {
    require(projectWithIdExists(projectid), "Project with id does not exist"); // Check if the project exists
    require(getIsProjectFunded(projectid), "Project should be funded in order to withdraw project payment"); // Check if the project is funded
    require(projects[projectid].owner == msg.sender, "You need to be the project owner to withdraw project payment"); // Check if the sender is the owner of the project
    require(!projects[projectid].allPaymentWithdrawn, "All payments are withdrawn, you cannot withdraw more"); // Check if all payments are not already withdrawn
    require(projects[projectid].paymentSchedule[projects[projectid].currPaymentIndex] > block.timestamp, "Deadline passed"); // Check if the payment deadline has not passed

    uint yesVotesCountOfTheCurrPayment = projects[projectid].yesVouteCountsOfPayments[projects[projectid].currPaymentIndex];
    require(yesVotesCountOfTheCurrPayment * 100 >= myGovMemberCount, "There is not enough yes votes for the current payment"); // Check if there are enough yes votes for the current payment
    uint currPaymentAmount = projects[projectid].paymentAmounts[projects[projectid].currPaymentIndex];
    require(reservedUSD_StableCoins >= currPaymentAmount, "There is not enough reserve amount"); // Check if there is enough reserve amount for the payment

    // Transfer the payment amount in USD Stable Coins to the project owner
    USD_BaseCoinContract.transfer(msg.sender, currPaymentAmount);
    reservedUSD_StableCoins -= currPaymentAmount; // Reduce the reserved amount
    projects[projectid].received_USD_amount += currPaymentAmount; // Update the received amount for the project
    projects[projectid].currPaymentIndex++; // Move to the next payment index
    if(projects[projectid].currPaymentIndex == projects[projectid].paymentSchedule.length) {
        projects[projectid].allPaymentWithdrawn = true; // Mark all payments as withdrawn if the last payment is reached
    }
}

// Function to get the amount of the next payment for the project
function getProjectNextPayment(uint projectid) public view returns(int next) {
    require(projectWithIdExists(projectid), "Project with id does not exist"); // Check if the project exists
    require(getIsProjectFunded(projectid), "Project should be funded in order to receive payment"); // Check if the project is funded
    require(!projects[projectid].allPaymentWithdrawn, "All of the payments are withdrawn, there is no next payment"); // Check if all payments are not already withdrawn

    return int(projects[projectid].paymentAmounts[projects[projectid].currPaymentIndex]); // Return the amount of the next payment
}

// Function to get the owner of a project
function getProjectOwner(uint projectid) public view returns(address projectowner) {
    require(projectWithIdExists(projectid), "Project with id does not exist"); // Check if the project exists
    return projects[projectid].owner; // Return the owner of the project
}

// Function to get information about a project, including its IPFS hash, vote deadline, payment amounts, and payment schedule
function getProjectInfo(uint activityid) public view returns(string memory ipfshash, uint votedeadline, uint [] memory paymentamounts, uint [] memory payschedule) {
    require(projectWithIdExists(activityid), "Project with id does not exist"); // Check if the project exists
    return (
        projects[activityid].ipfsHash,
        projects[activityid].voteDeadline,
        projects[activityid].paymentAmounts,
        projects[activityid].paymentSchedule
    ); // Return project information
}

// Function to get the total number of project proposals
function getNoOfProjectProposals() public view returns(uint numproposals) {
    return projects.length; // Return the total number of project proposals
}

// Function to get the total number of funded projects
function getNoOfFundedProjects () public view returns(uint numfunded) {
    uint result = 0;
    for(uint p = 0; p < projects.length; p++) {
        if(getIsProjectFunded(p)) {
            result++;
        }
    }
    return result; // Return the total number of funded projects
}

// Function to check if a project is funded based on reservation status and payment schedule
function getIsProjectFunded (uint projectid) public view returns(bool funded) {
    require(projectWithIdExists(projectid), "Project with id does not exist"); // Check if the project exists
    return (projects[projectid].isReserved) && (projects[projectid].paymentSchedule[projects[projectid].currPaymentIndex] > block.timestamp);
}

// Function to get the total amount of USD received by a project
function getUSDReceivedByProject (uint projectid) public view returns(uint amount) {
    require(projectWithIdExists(projectid), "Project with id does not exist"); // Check if the project exists
    return projects[projectid].received_USD_amount; // Return the total amount of USD received by the project
}

// Faucet function to distribute MyGov tokens to users
function faucet() public {
    require(balanceOf(address(this)) > 0, "No tokens left on contract"); // Check if there are remaining tokens in the contract
    require(!usedFaucet[msg.sender], "You already received token from contract"); // Check if the user has already received tokens
    this.transfer(msg.sender, 1); // Transfer 1 MyGov token to the user
    usedFaucet[msg.sender] = true; // Mark the user as having received tokens
    myGovMemberCount++; // Increment the MyGov member count
}


}
