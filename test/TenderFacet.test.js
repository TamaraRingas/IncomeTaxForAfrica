const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");
const { constants } = require("../contracts/Utils/TestConstants");
 //import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

let owner, ownerAddress;
let bob, chad, usdcWhale;
let bobAddress, chadAddress, usdcWhaleAddress;

const ERC20_ABI = require("../artifacts/@openzeppelin/contracts/token/ERC20/ERC20.sol/ERC20.json");
const USDC = new ethers.Contract(
    constants.POLYGON.USDC,
    ERC20_ABI.abi,
    ethers.provider
);