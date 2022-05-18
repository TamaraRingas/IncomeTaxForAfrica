const { ethers } = require("hardhat");
const { BigNumber } = require("@ethersproject/bignumber");
const { constants } = require("./TestConstants");

const ERC20_ABI = require("../../artifacts/@openzeppelin/contracts/token/ERC20/IERC20.sol/IERC20.json");

const DAI = new ethers.Contract(
  constants.POLYGON.DAI,
  ERC20_ABI.abi,
  ethers.provider
);

const USDC = new ethers.Contract(
  constants.POLYGON.USDC,
  ERC20_ABI.abi,
  ethers.provider
);

// Gets the time of the last block.
const currentTime = async () => {
  const { timestamp } = await ethers.provider.getBlock("latest");
  return timestamp;
};

// Increases the time in the EVM.
// seconds = number of seconds to increase the time by
const fastForward = async (seconds) => {
  await ethers.provider.send("evm_increaseTime", [seconds]);
  await ethers.provider.send("evm_mine", []);
};


const sendDaiFromWhale = async (amount, whaleSigner, toSigner, coreAddress) => {
  await DAI.connect(whaleSigner).transfer(toSigner.address, amount);
  await DAI.connect(toSigner).approve(coreAddress, amount)
}

const sendUsdcFromWhale = async (
  amount,
  whaleSigner,
  toSigner,
  coreAddress
) => {
  await USDC.connect(whaleSigner).transfer(toSigner.address, amount);
  await USDC.connect(toSigner).approve(coreAddress, amount);
};

const calcAmountAfterFees = (amountBeforeFees) => {
  return amountBeforeFees.sub(
    amountBeforeFees
      .mul(
        BigNumber.from(
          constants.DEPLOY.fees.admin + constants.DEPLOY.fees.protocol
        )
      )
      .div(BigNumber.from(constants.DEPLOY.SCALE))
  );
};

const createCitizenObject = async (firstName, secondName, primaryID, secondaryID, wallet) => {
  const citizen = {
    citizenID: 0,
    salary: 0,
    taxPercentage: 0,
    primarySectorID: primaryID,
    secondarySectorID: secondaryID,
    totalTaxPaid: 0,
    totalPriorityPoints: 20,
    walletAddress: wallet,
    firstName: firstName,
    secondName: secondName,
  };

  return citizen;
};

const createProposalObject = async (_tenderID, _sectorID, _companyID, _priceCharged, _supervisor, _hash) => {
  const proposal = {
    proposalID: 0,
    tenderID: _tenderID,
    sectorID: _sectorID,
    companyID: _companyID,
    priceCharged: _priceCharged,
    numberOfPublicVotes: 0,
    supervisor: _supervisor,
    storageHash: _hash,
    _proposalState: 0,
  };

  return proposal;
};

const createTenderObject = async (_sectorID, _closingDate, _threshold, _priorityPoints, _admin, _placeOfTender) => {
  const tender = {
    tenderID: 0,
    sectorID: _sectorID,
    dateCreated: 0,
    closingDate: _closingDate,
    _province: 0,
    _tenderState: 0,
    numberOfVotes: 0,
    threshold: _threshold,
    priorityPoints: _priorityPoints,
    admin: _admin,
    placeOfTender: _placeOfTender,
  };

  return tender;
};

module.exports = {
  currentTime: currentTime,
  fastForward: fastForward,
  sendDaiFromWhale: sendDaiFromWhale,
  createCitizenObject: createCitizenObject,
  createProposalObject: createProposalObject,
  createTenderObject: createTenderObject,
  sendUsdcFromWhale: sendUsdcFromWhale,
};