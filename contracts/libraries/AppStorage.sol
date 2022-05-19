// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { ITenderFacet } from "../interfaces/ITenderFacet.sol";


struct AppStorage {

    

    
    
    
    
    

    

    address USDAddress;
    
    address TreasuryAddress;

    

    IERC20 USDC;

}

library LibAppStorage {
    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }
}



