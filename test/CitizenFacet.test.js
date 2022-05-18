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
const DAI = new ethers.Contract(
  constants.POLYGON.DAI,
  ERC20_ABI.abi,
  ethers.provider
);
describe.only("Citizen Facet Tests", function () {
  beforeEach(async () => {
    [
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
    
    GovernanceContract = await ethers.getContractFactory("GovernanceFacet");
    GovernanceInstance = await GovernanceContract.connect(superAdmin).deploy(constants.POLYGON.USDC);

    SectorContract = await ethers.getContractFactory("SectorFacet");
    SectorInstance = await SectorContract.connect(superAdmin).deploy();

    CitizenContract = await ethers.getContractFactory("CitizenFacet");
    CitizenInstance = await CitizenContract.connect(superAdmin).deploy();

    await SectorInstance.connect(superAdmin).createSector("Health");
    await SectorInstance.connect(superAdmin).createSector("Education");
    await SectorInstance.connect(superAdmin).createSector("Road");
    await SectorInstance.connect(superAdmin).createSector("Mining");


    // Creating DAI token instance
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [constants.POLYGON.DAI_WHALE],
    });

    daiWhale = await ethers.getSigner(constants.POLYGON.DAI_WHALE);
    whaleAddress = await daiWhale.getAddress();

    // Give whale some ETH
    await superAdmin.sendTransaction({
      to: whaleAddress,
      value: ethers.utils.parseEther("1"),
    });

    startTime = await currentTime();
    endTime = startTime + constants.TEST.oneMonth;
  });

  describe("Citizen selecting sectors", function () {

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

        // console.log(await SectorInstance.connect(superAdmin).getSectorName(3));

        // await CitizenInstance.connect(superAdmin).selectSectors(0, 3, 2);

        // expect(await CitizenInstance.connect(superAdmin).getCitizenPrimaryID(0)).to.be.equal(3);
        // expect(await CitizenInstance.connect(superAdmin).getCitizenSecondaryID(0)).to.be.equal(2);

    });

  });

  describe("Citizen selecting sectors", function () {

    it("Correctly creates citizen", async () => {

  

    });

  });

});