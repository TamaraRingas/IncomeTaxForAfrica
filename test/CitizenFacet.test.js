const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");
const { constants } = require("../utils/TestConstants");

let owner, ownerAddress;
let bob, chad, usdcWhale;
let bobAddress, chadAddress, usdcWhaleAddress;

const ERC20_ABI = require("../artifacts/@openzeppelin/contracts/token/ERC20/ERC20.sol/ERC20.json");
const USDC = new ethers.Contract(
    constants.POLYGON.USDC,
    ERC20_ABI.abi,
    ethers.provider
);

describe("Citizen tests", function () {
    beforeEach(async () => {
        [
            owner,
            bob,
            chad,
        ] = await ethers.getSigners();

        ownerAddress = await owner.getAddress();
        bobAddress = await bob.getAddress();
        chadAddress = await chad.getAddress();

        CitizenContract = await ethers.getContractFactory("CitizenFacet");
        CitizenInstance = await CitizenContract.connect(owner).deploy();

        // Creating USDC token instance
        await hre.network.provider.request({
            method: "hardhat_impersonateAccount",
            params: [constants.POLYGON.USDC_WHALE],
        });

        usdcWhale = await ethers.getSigner(constants.POLYGON.USDC_WHALE);
        usdcWhaleAddress = await usdcWhale.getAddress();

        // setting up users with USDC
        await USDC.connect(usdcWhale).transfer(bobAddress, 300);
        await USDC.connect(usdcWhale).transfer(chadAddress, 300);

        //approving users or contract modules
        // await USDC.connect(donor1).approve(DonationsInstance.address, 300);
        // await USDC.connect(donor2).approve(DonationsInstance.address, 300);
        // await USDC.connect(donor3).approve(DonationsInstance.address, 300);

    })

    describe("Registering citizen tests", function () {

        it("registers the citizen correctly with correct parameters", async () => {

        });

    })

    describe("Selecting citizen contribution sectors", function () {

        it("reverts if sectors are the same", async () => {
            await expect(CitizenInstance.connect(owner).selectSectors(0, 1, 1)).to.be.revertedWith("SECTORS CANNOT BE THE SAME");
        })

        it("sets the sectors correctly", async() => {

        })

        it("Emits selection event", async () => {
            expect(await CitizenInstance.connect(donor1).selectSectors(0, 1, 1)).to.emit(0, 1, 2);
        })
      

    })

});