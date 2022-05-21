const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");
const { constants } = require("../contracts/Utils/TestConstants");
const {
  currentTime,
  fastForward,
  addWhaleBalance,
  transferDAI,
  approveDAI,
  createGrantTest,
  calcAdminFee,
  calcAmountAfterFees,
  createGrantObject,
  createProjectObject,
} = require("../contracts/Utils/TestUtils");
const { BigNumber } = require("ethers");
let superAdmin;
let supervisor;
let citizenOne, citizenTwo;
let employeeOne, employeeTwo, employeeThree;
let companyAdmin, tenderAdmin, proposalAdmin;

let superAdminAddress;
let supervisorAddress;
let citizenOneAddress, citizenTwoAddress;
let employeeOneAddress, employeeTwoAddress, employeeThreeAddress;
let companyAdminAddress, tenderAdminAddress, proposalAdminAddress;

let TreasuryContract, TreasuryInstance;

let startTime, endTime;

const ERC20_ABI = require("../artifacts/@openzeppelin/contracts/token/ERC20/IERC20.sol/IERC20.json");
const USDC = new ethers.Contract(
  constants.POLYGON.USDC,
  ERC20_ABI.abi,
  ethers.provider
);
describe.only("Treasury Tests", function () {
  beforeEach(async () => {
    [
      superAdmin,
      supervisor,
      citizenOne,
      citizenTwo,
      employeeOne,
      employeeTwo,
      employeeThree,
      companyAdmin,
      tenderAdmin,
      proposalAdmin,
    ] = await ethers.getSigners();

    superAdminAddress = await superAdmin.getAddress();
    supervisorAddress = await supervisor.getAddress();
    citizenOneAddress = await citizenOne.getAddress();
    citizenTwoAddress = await citizenTwo.getAddress();
    employeeOneAddress = await employeeOne.getAddress();
    employeeTwoAddress = await employeeTwo.getAddress();
    employeeThreeAddress = await employeeThree.getAddress();
    companyAdminAddress = await companyAdmin.getAddress();
    tenderAdminAddress = await tenderAdmin.getAddress();
    proposalAdminAddress = await proposalAdmin.getAddress();

    // Deploy core
    TreasuryContract = await ethers.getContractFactory("Treasury");
    TreasuryInstance = await TreasuryContract.connect(superAdmin).deploy(constants.POLYGON.USDC);

    ProposalContract = await ethers.getContractFactory("Proposal");
    ProposalInstance = await ProposalContract.connect(superAdmin).deploy();

    // Creating DAI token instance
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [constants.POLYGON.DAI_WHALE],
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

  describe("Getting Proposal State Details", function () {

    it("Should return state correctly", async () => {
      
    });

  });

  describe("Paying Phase One", function () {

    it("Should revert if not supervisor", async () => {
      console.log(citizenOneAddress);
       await expect(TreasuryInstance.connect(superAdmin).payPhaseOne(citizenOneAddress)).to.be.revertedWith("ONLY SUPERVISOR");
    });

  });

  describe("Closing Phase One", function () {

    it(" ", async () => {
      
    });

  });

  describe("Paying Phase Two", function () {

    it("Should revert if not supervisor", async () => {
      
    });

  });

  describe("Closing Phase Two", function () {

    it(" ", async () => {
      
    });

  });

  describe("Paying Phase Three", function () {

    it("Should revert if not supervisor", async () => {
      
    });

  });

  describe("Closing Phase Three", function () {

    it(" ", async () => {
      
    });

  });

  describe("Paying Phase Four", function () {

    it("Should revert if not supervisor", async () => {
      
    });

  });

  describe("Closing Phase Four", function () {

    it(" ", async () => {
      
    });

  });

});