const { BigNumber } = require("@ethersproject/bignumber");
const { ethers } = require("hardhat");

const CONSTANTS = {
  MUMBAI: {
    WMATIC: "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889",
    DAI: "0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F",
    aDAI: "0x639cB7b21ee2161DF9c882483C9D55c90c20Ca3e",
    AaveLendingPool: "0x9198F13B08E299d85E096929fA9781A1E3d5d827",
    AaveIncentivesController: "0xd41aE58e803Edf4304334acCE4DC4Ec34a63C644",
  },
  POLYGON: {
    WMATIC: "0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270",
    DAI: "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063",
    aDAI: "0x27F8D03b3a2196956ED754baDc28D73be8830A6e",
    AaveLendingPool: "0x8dFf5E27EA6b7AC08EbFdf9eB090F32ee9a30fcf",
    AaveIncentivesController: "0x357D51124f59836DeD84c8a1730D72B749d8BC23",
    DAI_WHALE: "0xB78e90E2eC737a2C0A24d68a0e54B410FFF3bD6B",
    USDC: "0x566368d78DBdEc50F04b588E152dE3cEC0d5889f",
    aUSDC: "0x625E7708f30cA75bfd92586e17077590C60eb4cD",
    USDC_WHALE: "0xADBaB4F38Ff9DCD71886f43B148bcad4A3081fB9",
  },
  DEPLOY: {
    fees: {
      protocol: 1000,
      admin: 1000,
    },
    SCALE: 10000,
  },
  TEST: {
    oneDai: ethers.utils.parseEther("1"),
    oneMonth: 2629800,
    twoMonths: 2629800 * 2,
    citizen1: {
      primarySectorID: 1,
      secondarySectorID: 2,
      firstname: "John",
      secondName: "Doe", //1 week in seconds
    },
    zeroAddr: "0x0000000000000000000000000000000000000000",
    projectID: 1,
    projectOne: "Project1",
    projectTwo: "Project2",
    projectThree: "Project3",
    projectSecond: "Project2",
    projectThird: "Project3",
    grantID: 1,
    protocolFee: 1000,
    adminFee: 1000,
  },
};

module.exports = {
  constants: CONSTANTS,
};