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

    //Percentage votes the tender needs to succeed 1000 - 10000
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

}

library LibAppStorage {
    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }
}



