/* global ethers */
/* eslint prefer-const: "off" */

async function deploy() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

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
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

exports.deploy = deploy