// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

struct User {
    string name;
    uint96 age; // uint96 = 8 bytes, to pack with 20 byte address below
    address walletAddress;
}

struct Tender {
    uint256 tenderID;
    uint256 sectorID;
    uint256 projectBudget;
    TenderState _tenderState;
    uint256 numberOfVotes;
    //Out of 10: 10 being high priority
    uint256 priorityPoints;
}

struct TaxPayerCompany {
    uint256 companyID;
    address wallet;
    string name;
}

struct Citizen {
    uint256 citizenID;
    uint256 citizenIdNumber;
    uint256 taxPercentage;
    uint256 primarySectoryID;
    uint256 secondarySectorID;
    uint256 totalTaxPaid;

    //Total taxPaid / 1000
    uint256 totalPriorityPoints;
    string firstName;
    string secondName;
}

struct Sector {
    uint256 sectorID;
    uint256 numberOfProjects;
    string sectorName;
}

struct Porposal {
    uint256 proposalID;
    uint256 projectID;
    uint256 sectorID;
    uint256 priceCharged;
    uint256 numberOfPublicVotes;
    uint256 numberOfGovernmentVotes;
    address headOfProject;
    string companyName;
}

enum TenderState {
    VOTING,
    APPROVED,
    DECLINED,
    PROPOSALS_OPEN,
    PROPOSALS_VOTING,
    GOVERNMENT_PROPOSAL_VOTING,
    AWARDED,
    DEVELOPMENT,
    CLOSED
}

// All state shared across the protocol goes here
struct AppStorage {
    mapping(uint256 => User) users;
    uint256 userCount;
    User oldestUser;
}

library LibAppStorage {
    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }
}
