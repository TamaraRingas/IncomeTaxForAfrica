// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../libraries/AppStorage.sol";

interface ISectorFacet {

    function createSector(string memory _name) external;
    
}