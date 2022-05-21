const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");
const { constants } = require("../contracts/Utils/TestConstants");
const {
  currentTime,
  fastForward,
  addWhaleBalance,
  transferUSDC,
  approveUSDC,
  calcAdminFee,
  calcAmountAfterFees,
  createGrantObject,
  createCitizenObject,
} = require("../contracts/Utils/TestUtils");
const { BigNumber } = require("ethers");
let superAdmin;
let citizenOne, citizenTwo;
let employeeOne, employeeTwo, employeeThree;
let companyAdmin, tenderAdmin, proposalAdmin;

let superAdminAddress;
let citizenOneAddress, citizenTwoAddress;
let employeeOneAddress, employeeTwoAddress, employeeThreeAddress;
let companyAdminAddress, tenderAdminAddress, proposalAdminAddress;

let CitizenContract, CitizenInstance;

let startTime, endTime;

const ERC20_ABI = require("../artifacts/@openzeppelin/contracts/token/ERC20/IERC20.sol/IERC20.json");
const USDC = new ethers.Contract(
  constants.POLYGON.USDC,
  ERC20_ABI.abi,
  ethers.provider
);
describe.only("Governance Tests", function () {
  beforeEach(async () => {
    [
      owner,
      superAdmin,
      citizenOne,
      citizenTwo,
      employeeOne,
      employeeTwo,
      employeeThree,
      companyAdmin,
      tenderAdmin,
      proposalAdmin,
    ] = await ethers.getSigners();
    
    ownerAddress = await owner.getAddress();
    superAdminAddress = await superAdmin.getAddress();
    citizenOneAddress = await citizenOne.getAddress();
    citizenTwoAddress = await citizenTwo.getAddress();
    employeeOneAddress = await employeeOne.getAddress();
    employeeTwoAddress = await employeeTwo.getAddress();
    employeeThreeAddress = await employeeThree.getAddress();
    companyAdminAddress = await companyAdmin.getAddress();
    tenderAdminAddress = await tenderAdmin.getAddress();
    proposalAdminAddress = await proposalAdmin.getAddress();

    // Deploy core
    
    GovernanceContract = await ethers.getContractFactory("Governance");
    GovernanceInstance = await GovernanceContract.connect(owner).deploy(constants.POLYGON.USDC);

    SectorContract = await ethers.getContractFactory("Sector");
    SectorInstance = await SectorContract.connect(superAdmin).deploy();

    CitizenContract = await ethers.getContractFactory("Citizen");
    CitizenInstance = await CitizenContract.connect(superAdmin).deploy();

    TenderContract = await ethers.getContractFactory("Tender");
    TenderInstance = await TenderContract.connect(superAdmin).deploy();

    ProposalContract = await ethers.getContractFactory("Proposal");
    ProposalInstance = await ProposalContract.connect(superAdmin).deploy();

    TreasuryContract = await ethers.getContractFactory("Treasury");
    TreasuryInstance = await TreasuryContract.connect(superAdmin).deploy();


    // Creating USDC token instance
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [constants.POLYGON.USDC_WHALE],
    });

    USDCWhale = await ethers.getSigner(constants.POLYGON.USDC_WHALE);
    whaleAddress = await USDCWhale.getAddress();

    // Give whale some ETH
    await superAdmin.sendTransaction({
      to: whaleAddress,
      value: ethers.utils.parseEther("1"),
    });

    startTime = await currentTime();
    endTime = startTime + constants.TEST.oneMonth;
  });

  describe("Set superAdmin", function () {

    it("Reverts if zero address", async () => {
      await expect(GovernanceInstance.connect(superAdmin).setSuperAdmin(Test.zeroAddr).to.be.revertedWith("CANNOT BE ZERO ADDRESS"));
  

    });

  });

  describe("Setting Tender Admin", function () {

    it("Reverts if zero address", async () => {

  

    });

  });

  describe("Setting Sector Admin", function () {

    it("Reverts if zero address", async () => {

  

    });

  });

  describe("Setting Supervisor", function () {

    it("Reverts if zero address", async () => {

  

    });

  });

  describe("Funding Treasury", function () {

    it(" ", async () => {

  

    });

  });

  describe("Updating Budget", function () {

    it(" ", async () => {

  

    });

  });

});