import { useEffect, useState } from "react";
import "./App.css";
import { Button, TextField, FormControl, Typography, Box } from '@mui/material';
import { createTheme, ThemeProvider, Container } from '@mui/material';

import {
  subscribeToAccountChanges,
  balanceOf,
  getUSDBalanceOfAccount,
  isMyGovMember,
  surveyWithIdExists,
  projectWithIdExists,
  tookSurvey,
  delegateVoteTo,
  donateUSD,
  donateMyGovToken,
  myGovBalanceOfContract,
  getUSDBalanceOfContract,
  faucet,
  transfer,
  init,
  voteForProjectProposal,
  voteForProjectPayment,
  submitProjectProposal,
  submitSurvey,
  takeSurvey,
  reserveProjectGrant,
  withdrawProjectPayment,
  getSurveyResults,
  getSurveyInfo,
  getSurveyOwner,
  getIsProjectFunded,
  getProjectNextPayment,
  getProjectOwner,
  getProjectInfo,
  getNoOfProjectProposals,
  getNoOfFundedProjects,
  getUSDReceivedByProject,
  getNoOfSurveys,
} from "./Web3";
import React from "react";

function App() {
  const [balance, setBalance] = useState(0);
  const [usdBalance, setUsdBalance] = useState(0);
  const [isMember, setIsMember] = useState(0);
  const [surveyExists, setSurveyExists] = useState(0);
  const [projectExists, setProjectExists] = useState(0);
  const [accountTookSurvey, setAccountTookSurvey] = useState(0);
  const [isFunded, setIsFunded] = useState(0);
  const [usdReceived, setUSDReceived] = useState(0);
  const [noFunded, setNoFunded] = useState(0);
  const [noProposals, setNoProposals] = useState(0);
  const [noSurveys, setNoSurveys] = useState(0);
  const [mgInContract, setMgInContract] = useState(0);
  const [usdInContract, setUsdInContract] = useState(0);
  const [selectedAccount, setSelectedAccount] = useState(0);

  const theme = createTheme({
    typography: {
      fontFamily: 'Montserrat, sans-serif',
    },
  });

  useEffect(() => {
    init();
  }, []);

  useEffect(() => {
    // Initialize the selected account
    if (window.ethereum) {
      window.ethereum.request({ method: 'eth_accounts' })
          .then(accounts => {
            if (accounts.length > 0) {
              setSelectedAccount(accounts[0]);
            }
          });
    }

    // Subscribe to account changes
    const unsubscribe = subscribeToAccountChanges(newAccount => {
      setSelectedAccount(newAccount);
    });

    // Clean up the subscription
    return () => {
      unsubscribe && unsubscribe();
    };
  }, []);

  const callFaucet = (event) => {
    event.preventDefault();
    faucet()
        .then((tx) => {
          console.log(tx);
        })
        .catch((err) => {
          console.log(err);
        });
  };

  const fetchBalanceOf = async (event) => {
    event.preventDefault();
    try {
      const coinCount = await balanceOf();
      setBalance(coinCount.toString());
      console.log("coin count: ", coinCount);
    } catch (err) {
      console.log(err);
    }
  };

  const fetchMGBalanceOfContract = async (event) => {
    event.preventDefault();
    try {
      const mgInContract = await myGovBalanceOfContract();
      setMgInContract(mgInContract.toString());
      console.log("mg in contract: ", mgInContract);
    } catch (err) {
      console.log(err);
    }
  };

  const fetchUSDBalanceOf = async (event) => {
    event.preventDefault();
    try {
      const usdCount = await getUSDBalanceOfAccount();
      setUsdBalance(usdCount.toString());
      console.log("usd count: ", usdCount);
    } catch (err) {
      console.log(err);
    }
  };

  const fetchUSDBalanceOfContract = async (event) => {
    event.preventDefault();
    try {
      const usdInContract = await getUSDBalanceOfContract();
      setUsdInContract(usdInContract.toString());
      console.log("usd count in contract: ", usdInContract);
    } catch (err) {
      console.log(err);
    }
  };

  const handleIsMyGovMember = async (event) => {
    event.preventDefault();
    try {
      const isMember = await isMyGovMember();
      setIsMember(isMember.toString());
      console.log("is member: ", isMember);
    } catch (err) {
      console.log(err);
    }
  };

  const sendDonateUSD = (valueInWei) => {
    donateUSD(valueInWei)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleDonateUSD = (event) => {
    event.preventDefault();
    sendDonateUSD(event.target.usd.value);
  };

  const handleTransfer = (event) => {
    event.preventDefault();
    transfer(event.target.elements.adress.value, event.target.elements.amount.value)
        .then((tx) => {
          console.log(tx);
        })
        .catch((err) => {
          console.log(err);
        });
  };

  const handleSurveyExists = async (event) => {
    event.preventDefault();
    try {
      const surveyExists = await surveyWithIdExists(event.target.surveyid.value);
      setSurveyExists(surveyExists.toString());
      console.log("survey exists: ", surveyExists);
    } catch (err) {
      console.log(err);
    }
  };

  const handleProjectExists = async (event) => {
    event.preventDefault();
    try {
      const projectExists = await projectWithIdExists(event.target.projectid.value);
      setProjectExists(projectExists.toString());
      console.log("project exists: ", projectExists);
    } catch (err) {
      console.log(err);
    }
  };

  const handleTookSurvey = async (event) => {
    event.preventDefault();
    try {
      const accountTookSurvey = await tookSurvey(event.target.surveyId.value, event.target.adress.value);
      setAccountTookSurvey(accountTookSurvey.toString());
      console.log("account took survey: ", accountTookSurvey);
    } catch (err) {
      console.log(err);
    }
  };

  const sendDelegateVoteTo = (address, projectId) => {
    delegateVoteTo(address, projectId)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleDelegateVoteTo = (event) => {
    event.preventDefault();
    sendDelegateVoteTo(
      event.target.address.value,
      event.target.projectId.value
    );
  };

  const sendDonateMyGovToken = (amount) => {
    donateMyGovToken(amount)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleDonateMyGovToken = (event) => {
    event.preventDefault();
    sendDonateMyGovToken(event.target.amount.value);
  };

  const sendVoteForProjectProposal = (projectId, choice) => {
    voteForProjectProposal(projectId, choice)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleVoteForProjectProposal = (event) => {
    event.preventDefault();
    sendVoteForProjectProposal(
      event.target.projectId.value,
      event.target.choice.value
    );
  };

  const sendVoteForProjectPayment = (projectId, choice) => {
    voteForProjectPayment(projectId, choice)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleVoteForProjectPayment = (event) => {
    event.preventDefault();
    sendVoteForProjectPayment(
      event.target.projectId.value,
      event.target.choice.value
    );
  };

  let handleSubmitProjectProposal = (event) => {
    event.preventDefault();
    sendSubmitProjectProposal(
      event.target.ipfshash.value,
      event.target.votedeadline.value,
      event.target.paymentamounts.value.split(","),
      event.target.payschedule.value.split(","),
    );
  };

  const sendSubmitProjectProposal = (
    ipfshash,
    votedeadline,
    paymentamounts,
    payschedule,
    valueInWei
  ) => {
    submitProjectProposal(
      ipfshash,
      votedeadline,
      paymentamounts,
      payschedule,
      valueInWei
    )
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  const sendSubmitSurvey = (
    ipfshash,
    surveydeadline,
    numchoices,
    atmostchoice,
  ) => {
    submitSurvey(ipfshash, surveydeadline, numchoices, atmostchoice)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleSubmitSurvey = (event) => {
    event.preventDefault();
    sendSubmitSurvey(
      event.target.ipfshash.value,
      event.target.surveydeadline.value,
      event.target.numchoices.value,
      event.target.atmostchoice.value,
    );
  };

  const sendTakeSurvey = (surveyid, choices) => {
    takeSurvey(surveyid, choices)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleTakeSurvey = (event) => {
    event.preventDefault();
    sendTakeSurvey(
      event.target.surveyid.value,
      event.target.choices.value.split(",")
    );
  };

  const sendReserveProjectGrant = (projectid) => {
    reserveProjectGrant(projectid)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleReserveProjectGrant = (event) => {
    event.preventDefault();
    sendReserveProjectGrant(event.target.projectid.value);
  };

  const sendWithdrawProjectPayment = (projectid) => {
    withdrawProjectPayment(projectid)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleWithdrawProjectPayment = (event) => {
    event.preventDefault();
    sendWithdrawProjectPayment(event.target.projectid.value);
  };

  const sendGetSurveyResults = (surveyid) => {
    getSurveyResults(surveyid)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleGetSurveyResults = (event) => {
    event.preventDefault();
    sendGetSurveyResults(event.target.surveyid.value);
  };

  const sendGetSurveyInfo = (surveyid) => {
    getSurveyInfo(surveyid)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleGetSurveyInfo = (event) => {
    event.preventDefault();
    sendGetSurveyInfo(event.target.surveyid.value);
  };

  const sendGetSurveyOwner = (surveyid) => {
    getSurveyOwner(surveyid)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleGetSurveyOwner = (event) => {
    event.preventDefault();
    sendGetSurveyOwner(event.target.surveyid.value);
  };


  let handleGetIsProjectFunded = async (event) => {
    event.preventDefault();
    try {
      const isFunded = await getIsProjectFunded(event.target.projectid.value);
      setIsFunded(isFunded.toString());
      console.log("project is funded: ", isFunded);
    } catch (err) {
      console.log(err);
    }
  };

  const sendGetProjectNextPayment = (projectid) => {
    getProjectNextPayment(projectid)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleGetProjectNextPayment = (event) => {
    event.preventDefault();
    sendGetProjectNextPayment(event.target.projectid.value);
  };

  const sendGetProjectOwner = (projectid) => {
    getProjectOwner(projectid)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleGetProjectOwner = (event) => {
    event.preventDefault();
    sendGetProjectOwner(event.target.projectid.value);
  };

  const sendGetProjectInfo = (projectid) => {
    getProjectInfo(projectid)
      .then((tx) => {
        console.log(tx);
      })
      .catch((err) => {
        console.log(err);
      });
  };

  let handleGetProjectInfo = (event) => {
    event.preventDefault();
    sendGetProjectInfo(event.target.projectid.value);
  };


  const handleGetNoOfFundedProjects = async (event) => {
    event.preventDefault();
    try {
      const noFunded = await getNoOfFundedProjects();
      setNoFunded(noFunded.toString());
      console.log("number of funded projects: ", noFunded);
    } catch (err) {
      console.log(err);
    }
  };

  const handleGetUSDReceivedByProject = async (event) => {
    event.preventDefault();
    try {
      const usdReceived = await getUSDReceivedByProject(event.target.projectId.value);
      setUSDReceived(usdReceived.toString());
      console.log("usd received by project: ", usdReceived);
    } catch (err) {
      console.log(err);
    }
  };

  const handleGetNoOfProjectProposals = async (event) => {
    event.preventDefault();
    try {
      const noProposals = await getNoOfProjectProposals();
      setNoProposals(noProposals.toString());
      console.log("no of project proposals: ", noProposals);
    } catch (err) {
      console.log(err);
    }
  };

  const handleGetNoOfSurveys=  async (event) => {
    event.preventDefault();
    try {
      const noSurveys = await getNoOfSurveys();
      setNoSurveys(noSurveys.toString());
      console.log(" no of surveys: ", noSurveys);
    } catch (err) {
      console.log(err);
    }
  };



  return (

      <ThemeProvider theme={theme}>
        <Container sx={{ padding: '20px', marginBottom: '100px' }}>
          <div className="App">

            <Typography variant="h2" align="center" gutterBottom style={{ marginBottom: '100px', marginTop: '20px' }}>
              My Governance Token App
            </Typography>

            <Typography variant="h5" align="center" gutterBottom style={{ marginBottom: '70px', marginTop: '20px' }}>
              Current Account: {selectedAccount || 'None'}
            </Typography>


            <form onSubmit={callFaucet} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Call Faucet Function
              </Typography>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Call Faucet
                </Button>
              </Box>
            </form>

            <form onSubmit={fetchBalanceOf} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Fetch MyGov balance of the current user
              </Typography>

              <FormControl fullWidth margin="normal">
                <TextField
                    name="balance"
                    type="text"
                    variant="outlined"
                    value={balance}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Fetch Balance
                </Button>
              </Box>
            </form>

            <form onSubmit={handleTransfer} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Transfer MyGov tokens to another user
              </Typography>

              <FormControl fullWidth margin="normal">
                <TextField
                    label="Adress"
                    name="adress"
                    type="text"
                    variant="outlined"
                />
                <TextField
                    label="Amount"
                    name="amount"
                    type="text"
                    variant="outlined"
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Transfer Tokens
                </Button>
              </Box>
            </form>

            <form onSubmit={handleIsMyGovMember} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Check whether the current account is a MyGov member
              </Typography>

              <FormControl fullWidth margin="normal">
                <TextField
                    name="isMember"
                    type="text"
                    variant="outlined"
                    value={isMember}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Check Membership
                </Button>
              </Box>
            </form>

            <form onSubmit={fetchUSDBalanceOf} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Fetch USD balance of the current user
              </Typography>

              <FormControl fullWidth margin="normal">
                <TextField
                    name="balance"
                    type="text"
                    variant="outlined"
                    value={usdBalance}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Fetch USD Balance
                </Button>
              </Box>
            </form>

            <form onSubmit={handleDonateUSD} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Donate USD to this contract
              </Typography>
              <FormControl fullWidth margin="normal">
                <TextField
                    label="USD"
                    name="usd"
                    type="text"
                    variant="outlined"
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  submit
                </Button>
              </Box>
            </form>

            <form onSubmit={fetchUSDBalanceOfContract} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Fetch USD balance of the contract
              </Typography>

              <FormControl fullWidth margin="normal">
                <TextField
                    name="balance"
                    type="text"
                    variant="outlined"
                    value={usdInContract}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Fetch
                </Button>
              </Box>
            </form>

            <form onSubmit={handleDonateMyGovToken} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Donate MyGov token to this contract
              </Typography>
              <FormControl fullWidth margin="normal">
                <TextField
                    label="MyGov tokens"
                    name="mygov"
                    type="text"
                    variant="outlined"
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  submit
                </Button>
              </Box>
            </form>

            <form onSubmit={fetchMGBalanceOfContract} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Fetch MyGov balance of the contract
              </Typography>

              <FormControl fullWidth margin="normal">
                <TextField
                    name="balance"
                    type="text"
                    variant="outlined"
                    value={mgInContract}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Fetch Balance
                </Button>
              </Box>
            </form>

            <Typography variant="h5" align="center" gutterBottom style={{ marginBottom: '70px', marginTop: '20px' }}>
              Project Services
            </Typography>

            <form onSubmit={handleSubmitProjectProposal} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Submit Project Proposal
              </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="IPFS Hash" name="ipfshash" type="text" variant="outlined" />
                <TextField label="Vote Deadline" name="votedeadline" type="text" variant="outlined" />
                <TextField label="Payment Amounts" name="paymentamounts" type="text" variant="outlined" />
                <TextField label="Pay Schedule" name="payschedule" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleProjectExists} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Does the project exist?
              </Typography>

              <FormControl fullWidth margin="normal">
                <TextField label="Project Id" name="projectid" type="text" variant="outlined" />
                <TextField
                    name="exists"
                    type="text"
                    variant="outlined"
                    value={projectExists}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Check
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetProjectOwner} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get Project Owner      </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Project Id" name="projectid" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetProjectInfo} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get Project Info      </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Project Id" name="projectid" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleDelegateVoteTo} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Delegate Vote To
              </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Address" name="address" type="text" variant="outlined" />
                <TextField label="Project Id" name="projectId" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleVoteForProjectProposal} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Vote For Project Proposal
              </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Project Id" name="projectId" type="text" variant="outlined" />
                <TextField label="Choice" name="choice" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetNoOfProjectProposals} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get number of project proposals     </Typography>
              <FormControl fullWidth margin="normal">
                <TextField
                    name="noProposals"
                    type="text"
                    variant="outlined"
                    value={noProposals}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Check
                </Button>
              </Box>
            </form>

            <form onSubmit={handleVoteForProjectPayment} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Vote For Project Payment
              </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Project Id" name="projectId" type="text" variant="outlined" />
                <TextField label="Choice" name="choice" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleReserveProjectGrant} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Reserve Project Grant
              </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Project Id" name="projectid" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleWithdrawProjectPayment} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Withdraw Project Payment        </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Project Id" name="projectid" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetIsProjectFunded} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get Is Project Funded      </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Project Id" name="projectid" type="text" variant="outlined" />
                <TextField
                    name="isFunded"
                    type="text"
                    variant="outlined"
                    value={isFunded}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Check
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetNoOfFundedProjects} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get number of funded projects      </Typography>
              <FormControl fullWidth margin="normal">
                <TextField
                    name="noFunded"
                    type="text"
                    variant="outlined"
                    value={noFunded}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Check
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetUSDReceivedByProject} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get USD received by project      </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Project Id" name="projectId" type="text" variant="outlined" />
                <TextField
                    name="usdReceived"
                    type="text"
                    variant="outlined"
                    value={usdReceived}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Check
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetProjectNextPayment} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get Project Next Payment      </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Project Id" name="projectid" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <Typography variant="h5" align="center" gutterBottom style={{ marginBottom: '70px', marginTop: '20px' }}>
              Survey Services
            </Typography>

            <form onSubmit={handleSubmitSurvey} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Submit Survey
              </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="IPFS Hash" name="ipfshash" type="text" variant="outlined" />
                <TextField label="Survey Deadline" name="surveydeadline" type="text" variant="outlined" />
                <TextField label="Number of Choices" name="numchoices" type="text" variant="outlined" />
                <TextField label="Max. Number of Choices" name="atmostchoice" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleSurveyExists} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Does the survey exist?
              </Typography>

              <FormControl fullWidth margin="normal">
                <TextField label="Survey Id" name="surveyid" type="text" variant="outlined" />
                <TextField
                    name="exists"
                    type="text"
                    variant="outlined"
                    value={surveyExists}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Check
                </Button>
              </Box>
            </form>

            <form onSubmit={handleTakeSurvey} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Take Survey
              </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Survey Id" name="surveyid" type="text" variant="outlined" />
                <TextField label="Choices" name="choices" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleTookSurvey} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Did the account take the survey?
              </Typography>

              <FormControl fullWidth margin="normal">
                <TextField label="Survey Id" name="surveyId" type="text" variant="outlined" />
                <TextField label="Adress" name="adress" type="text" variant="outlined" />
                <TextField
                    name="took"
                    type="text"
                    variant="outlined"
                    value={accountTookSurvey}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>

              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Check
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetSurveyInfo} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get Survey Info      </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Survey Id" name="surveyid" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetSurveyOwner} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get Survey Owner      </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Survey Id" name="surveyid" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetSurveyResults} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get Survey Results      </Typography>
              <FormControl fullWidth margin="normal">
                <TextField label="Survey Id" name="surveyid" type="text" variant="outlined" />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Submit
                </Button>
              </Box>
            </form>

            <form onSubmit={handleGetNoOfSurveys} style={{ marginTop: '20px' }}>
              <Typography variant="h5" component="h2" gutterBottom align="left">
                Get Number Of Surveys
              </Typography>

              <FormControl fullWidth margin="normal">
                <TextField
                    name="noSurveys"
                    type="text"
                    variant="outlined"
                    value={noSurveys}
                    InputProps={{
                      readOnly: true,
                    }}
                />
              </FormControl>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end' }}>
                <Button type="submit" variant="outlined" color="primary">
                  Check
                </Button>
              </Box>
            </form>

          </div>
        </Container>
      </ThemeProvider>
  );
}

export default App;
