const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");
const { constants } = require("../contracts/Utils/TestConstants");
 //import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

let owner, ownerAddress;
let bob, chad, usdcWhale;
let bobAddress, chadAddress, usdcWhaleAddress;

