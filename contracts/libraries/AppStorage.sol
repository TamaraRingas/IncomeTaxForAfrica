// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

mapping(uint256 => Proposal) proposals;
mapping(uint256 => Citizen) citizens;
mapping(uint256 => Sector) sectors;
mapping(uint256 => TaxPayerCompany) companies;

uint256 numberOfProjects;
uint256 numberOfCitizens;
uint256 numberOfSectors;
uint256 numberOfCompanies;


enum TenderState {
    VOTING,
    APPROVED,
    DECLINED,
    TENDERING,
    TENDER_VOTING,
    GOVERNMENT_VOTING,
    AWARDED,
    DEVELOPMENT,
    CLOSED
}

enum Province {
    EASTERN_CAPE,
    WESTERN_CAPE,
    GAUTENG,
    KWA_ZULU_NATAL,
    NORTHERN_CAPE,
    LIMPOPO,
    MPUMALANGA,
    NORTH_WEST,
    FREESTATE
}

struct Tender {
    uint256 tenderID;
    uint256 sectorID;
    uint256 dateCreated;
    uint256 closingDate;
    Province _province;
    TenderState _tenderState;
    uint256 numberOfVotes;
    uint256 threshold;

    //Out of 10: 10 being high priority
    uint256 priorityPoints;

    address admin;

    string placeOfTender;
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
    address walletAddress;
    string firstName;
    string secondName;
}

struct Sector {
    uint256 sectorID;
    Citizen[] sectorAdmins;
    uint256 numberOfProjects;
    string sectorName;
}

struct Proposal {
    uint256 proposalID;
    uint256 projectID;
    uint256 sectorID;
    uint256 priceCharged;
    uint256 numberOfPublicVotes;
    uint256 numberOfGovernmentVotes;
    address headOfProject;
    string companyName;
}

struct User {
    string name;
    uint96 age; // uint96 = 8 bytes, to pack with 20 byte address below
    address walletAddress;
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
