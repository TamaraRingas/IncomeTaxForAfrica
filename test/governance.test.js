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
describe("Company Facet Tests", function () {
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

  describe("Creating company", function () {

    it("Reverts if sectors are the same", async () => {

      
      let testCitizenOne = await createCitizenObject("John", "Doe", 1, 2, citizenOneAddress);

      await CitizenInstance.connect(superAdmin).register(testCitizenOne);

      await expect(CitizenInstance.connect(superAdmin).selectSectors(0, 1, 1)).to.be.revertedWith("SECTORS CANNOT BE THE SAME");

    
    });

    it("Reverts if primary sector is not valid", async () => {

        let testCitizenOne = await createCitizenObject("John", "Doe", 1, 2, citizenOneAddress);

        await CitizenInstance.connect(superAdmin).register(testCitizenOne);

        await expect(CitizenInstance.connect(superAdmin).selectSectors(0, 5, 2)).to.be.revertedWith("INVALID PRIMARY SECTOR ID");
    
    });

    it("Reverts if secondary sector is not valid", async () => {

        let testCitizenOne = await createCitizenObject("John", "Doe", 1, 2, citizenOneAddress);

        await CitizenInstance.connect(superAdmin).register(testCitizenOne);
        
        await expect(CitizenInstance.connect(superAdmin).selectSectors(0, 2, 5)).to.be.revertedWith("INVALID SECONDARY SECTOR ID");
    
    });

    it("Reverts if caller isnt updating their own settings", async () => {

      let testCitizenOne = await createCitizenObject("John", "Doe", 1, 2, citizenOneAddress);

      await CitizenInstance.connect(superAdmin).register(testCitizenOne);
      
      //await expect(CitizenInstance.connect(superAdmin).selectSectors(0, 0, 1)).to.be.revertedWith("CAN ONLY UPDATE OWN SETTINGS");
    
    });

    it("Correctly updates sectors", async () => {

    
    });

  });

  describe("Paying tax", function () {

    it("Correctly creates citizen", async () => {

  

    });

  });

  describe("Updating employee salary and tax percentage", function () {

    it("Correctly creates citizen", async () => {

  

    });

  });

  describe("Add employee", function () {

    it("Correctly creates citizen", async () => {

  

    });

  });

});