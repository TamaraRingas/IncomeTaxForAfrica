// const { expect } = require("chai");
// const { ethers } = require("hardhat");
// const hre = require("hardhat");
// const { constants } = require("../contracts/Utils/TestConstants");
// const {
//   currentTime,
//   fastForward,
//   addWhaleBalance,
//   transferDAI,
//   approveDAI,
//   createGrantTest,
//   calcAdminFee,
//   calcAmountAfterFees,
//   createGrantObject,
//   createCitizenObject,
//   createTenderObject,
//   createProposalObject,
// } = require("../contracts/Utils/TestUtils");
// const { BigNumber } = require("ethers");
// let superAdmin;
// let citizenOne, citizenTwo;
// let employeeOne, employeeTwo, employeeThree;
// let companyAdmin, tenderAdmin, proposalAdmin;

// let superAdminAddress;
// let citizenOneAddress, citizenTwoAddress;
// let employeeOneAddress, employeeTwoAddress, employeeThreeAddress;
// let companyAdminAddress, tenderAdminAddress, proposalAdminAddress;

// let CitizenContract, CitizenInstance;
// let TenderContract, TenderInstance;
// let GovernanceContract, GovernanceInstance;
// let SectorContract, SectorInstance;

// let startTime, endTime;

// const ERC20_ABI = require("../artifacts/@openzeppelin/contracts/token/ERC20/IERC20.sol/IERC20.json");
// const DAI = new ethers.Contract(
//   constants.POLYGON.DAI,
//   ERC20_ABI.abi,
//   ethers.provider
// );
// describe("Tender Facet Tests", function () {
//   beforeEach(async () => {
//     [
//       superAdmin,
//       citizenOne,
//       citizenTwo,
//       employeeOne,
//       employeeTwo,
//       employeeThree,
//       companyAdmin,
//       tenderAdmin,
//       proposalAdmin,
//     ] = await ethers.getSigners();

//     superAdminAddress = await superAdmin.getAddress();
//     citizenOneAddress = await citizenOne.getAddress();
//     citizenTwoAddress = await citizenTwo.getAddress();
//     employeeOneAddress = await employeeOne.getAddress();
//     employeeTwoAddress = await employeeTwo.getAddress();
//     employeeThreeAddress = await employeeThree.getAddress();
//     companyAdminAddress = await companyAdmin.getAddress();
//     tenderAdminAddress = await tenderAdmin.getAddress();
//     proposalAdminAddress = await proposalAdmin.getAddress();

    
//     GovernanceContract = await ethers.getContractFactory("GovernanceFacet");
//     GovernanceInstance = await GovernanceContract.connect(superAdmin).deploy(constants.POLYGON.USDC);

//     TenderContract = await ethers.getContractFactory("TenderFacet");
//     TenderInstance = await TenderContract.connect(superAdmin).deploy();

//     CitizenContract = await ethers.getContractFactory("CitizenFacet");
//     CitizenInstance = await CitizenContract.connect(superAdmin).deploy();

//     SectorContract = await ethers.getContractFactory("SectorFacet");
//     SectorInstance = await SectorContract.connect(superAdmin).deploy();

//     await SectorInstance.connect(superAdmin).createSector("Health");
//     await SectorInstance.connect(superAdmin).createSector("Education");
//     await SectorInstance.connect(superAdmin).createSector("Road");
//     await SectorInstance.connect(superAdmin).createSector("Mining");


//     // Creating DAI token instance
//     await hre.network.provider.request({
//       method: "hardhat_impersonateAccount",
//       params: [constants.POLYGON.DAI_WHALE],
//     });

//     daiWhale = await ethers.getSigner(constants.POLYGON.DAI_WHALE);
//     whaleAddress = await daiWhale.getAddress();

//     // Give whale some ETH
//     await superAdmin.sendTransaction({
//       to: whaleAddress,
//       value: ethers.utils.parseEther("1"),
//     });

//     startTime = await currentTime();
//     endTime = startTime + constants.TEST.oneMonth;
//   });

//   describe("Creating tender", function () {

//     it("Reverts if sectors are the same", async () => {

    
//     });

//     it("Reverts if primary sector is not valid", async () => {

      
//     });

//     it("Reverts if secondary sector is not valid", async () => {
    
//     });

//     it("Reverts if caller isnt updating their own settings", async () => {

    
//     });

//     it("Correctly updates sectors", async () => {

    
//     });

//   });

//   describe("Voting on a tender", function () {

//     it.only("Reverts if tender is not in voting state", async () => {

//       let testCitizenOne = await createCitizenObject("John", "Doe", 1, 2, citizenOneAddress);

//       await CitizenInstance.connect(superAdmin).register(testCitizenOne);

//       let testTender = await createTenderObject(1, endTime, 5000, 8, tenderAdminAddress, "Random Town");

//       await TenderInstance.connect(superAdmin).createTender(testTender);

//       console.log("check test");

//       await expect(TenderInstance.connect(superAdmin).voteForTender(0, 0)).to.be.revertedWith("TENDER NOT IN VOTING STAGE");


//     });

//     it("Reverts if sender does not have enough priority points", async () => {
    

//     });

//   });

//   describe("Setters", function () {

//     it("Correctly creates citizen", async () => {

//     });

//   });

//   describe("State changing functions", function () {

//     it("Correctly creates citizen", async () => {

//     });

//   });

// });