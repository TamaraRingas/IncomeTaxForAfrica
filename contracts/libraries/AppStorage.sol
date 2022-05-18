// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { ITenderFacet } from "../interfaces/ITenderFacet.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


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

 enum ProposalState {
        PROPOSED,
        UNSUCCESSFULL,
        SUCCESSFULL,
        PHASE_1,
        PHASE_2,
        PHASE_3,
        PHASE_4,
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

    //How many votes the tender needs to succeed
    uint256 threshold;

    //Out of 10: 10 being high priority
    uint256 priorityPoints;

    address admin;

    string placeOfTender;
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

    uint256 numberOfProposals;
    uint256 numberOfCitizens;
    uint256 numberOfSectors;
    uint256 numberOfCompanies;
    uint256 numberOfTenders;

    uint256 treasuryBalance;

    address USDAddress;
    
    address TreasuryAddress;

    address superAdmin;

    IERC20 USDC;

    Province _province;
}

struct TaxPayerCompany {
    uint256 companyID;
    uint256 numberOfEmployees;
    address admin;
    address wallet;
    string name;
    mapping(uint256 => bool) employees;
    mapping(uint256 => Proposal) currentProposals;
}

struct Citizen {
    uint256 citizenID;
    uint256 salary;

    //Stored out of 10_000 for scale
    uint256 taxPercentage;
    uint256 primarySectorID;
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
    uint256 numberOfTenders;
    uint256 currentFunds;
    uint256 budget;
    string sectorName;
    bool budgetReached;
    mapping(address => bool) sectorAdmins;
}

struct Proposal {
    uint256 proposalID;
    uint256 tenderID;
    uint256 sectorID;
    uint256 companyID;
    uint256 priceCharged;
    uint256 numberOfPublicVotes;
    address supervisor;
    string companyName;
    string storageHash;
    ProposalState _proposalState;
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

    modifier onlyCitizen(address citizen) {
        uint256 _citizenID = s.userAddressesToIDs[msg.sender];
        require(_citizenID < s.numberOfCitizens, "ONLY CITIZENS");
        _;
    }

    modifier onlySuperAdmin() {
        require(msg.sender == s.superAdmin, "ONLY SUPER ADMIN");
        _;
    }

    modifier onlySupervisor(uint256 _proposalID) {
        require(msg.sender == s.proposals[_proposalID].supervisor, "ONLY SUPERVISOR");
        _;
    }

    modifier onlySectorAdmins(uint256 _sectorID) {
        require(s.sectors[_sectorID].sectorAdmins[msg.sender] == true, "ONLY SECTOR ADMINS");
        _;
    }

     modifier onlyCompanyAdmin(uint256 _companyID) {
        require(msg.sender == s.companies[_companyID].admin, "ONLY COMPANY ADMIN");
        _;
    }

}


