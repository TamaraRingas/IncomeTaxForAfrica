// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { ITenderFacet } from "../interfaces/ITenderFacet.sol";

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

enum TenderState {
        VOTING,
        APPROVED,
        DECLINED,
        PROPOSING,
        PROPOSAL_VOTING,
        AWARDED,
        DEVELOPMENT,
        CLOSED
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


struct Treasury {
    uint256 balance;
}

struct AppStorage {

    mapping(uint256 => Tender) tenders;
    mapping(uint256 => Proposal) proposals;
    mapping(uint256 => Citizen) citizens;
    mapping(uint256 => Sector) sectors;
    mapping(uint256 => TaxPayerCompany) companies;

    //Mapping of companyID => CitizenID => salary
    mapping(uint256 => mapping(uint256 => uint256)) employeeSalaries;

    //Mapping of citizen addresses => id's
    mapping(address => uint256) userAddressesToIDs;

    mapping(address => bool) supervisors

    uint256 numberOfProposals;
    uint256 numberOfCitizens;
    uint256 numberOfSectors;
    uint256 numberOfCompanies;
    uint256 numberOfTenders;

    //TenderState _tenderState;
    Province _province;
}

struct TaxPayerCompany {
    uint256 companyID;
    address admin;
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

library LibAppStorage {
    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }
}

contract Modifiers {

    AppStorage internal s;

    modifier onlyAdmin(uint256 _tenderID) {
        require(msg.sender == s.tenders[_tenderID].admin, "ONLY ADMIN");
        _;
    }

    modifier onlyCitizen(uint256 _citizenID) {
        require(_citizenID < s.numberOfCitizens, "ONLY CITIZENS");
        _;
    }

    modifier onlySupervisor(address owner) {
        require(supervisors[msg.sender] == true, "ONLY SUPERVISORS");
        _;
    }

    modifier onlyOwner(address owner) {
        require(msg.sender == owner, "ONLY OWNER");
        _;
    }
}


