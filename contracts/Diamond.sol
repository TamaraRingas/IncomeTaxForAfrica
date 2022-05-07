// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/******************************************************************************\
* Author: Ben Sparks
* Foundry Diamond Demo
* 
* Uses Nick Mudge's diamond-1 as reference: https://github.com/mudgen/diamond-1
/******************************************************************************/

import "./libraries/AppStorage.sol";
import "./libraries/LibDiamond.sol";
import "./interfaces/IDiamondCut.sol";
import "./interfaces/IDiamondLoupe.sol";
import "./interfaces/IERC165.sol";
import "./interfaces/IERC173.sol";


contract Diamond {

    AppStorage s;

    constructor(address _contractOwner, address _diamondCutFacet) {
        LibDiamond.setContractOwner(_contractOwner);

        // Add the diamondCut external function from the diamondCutFacet
        // NOTE: Alternatively, could pass final cut object as calldata param
        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);
        functionSelectors[0] = IDiamondCut.diamondCut.selector;
        cut[0] = IDiamondCut.FacetCut({
            facetAddress: _diamondCutFacet,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });
        LibDiamond.diamondCut(cut, address(0), new bytes(0));
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        LibDiamond.DiamondStorage storage ds;
        bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
        // get diamond storage
        assembly {
            ds.slot := position
        }
        // get facet from function selector
        address facet = ds.facetAddressAndSelectorPosition[msg.sig].facetAddress;
        require(facet != address(0), "Diamond: Function does not exist");
        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
             // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
    }

    receive() external payable {}
}