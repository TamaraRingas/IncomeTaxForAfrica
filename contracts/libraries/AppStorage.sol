// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { ITenderFacet } from "../interfaces/ITenderFacet.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

struct AppStorage {

    

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



