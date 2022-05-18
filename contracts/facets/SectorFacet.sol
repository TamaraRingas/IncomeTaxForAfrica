// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ISectorFacet.sol";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";
import "hardhat/console.sol";

contract SectorFacet is ISectorFacet, Modifiers {

    //AppStorage internal s;

    constructor() {
        s.superAdmin = msg.sender;
    }

    function createSector(string memory _name) public onlySuperAdmin(){

        Sector storage _sector = s.sectors[s.numberOfSectors];

       _sector.sectorID = s.numberOfSectors;
       _sector.numberOfTenders = 0;
       _sector.currentFunds = 0;
       _sector.budget = 0;
       _sector.budgetReached = false;
       _sector.sectorName = _name;

        s.numberOfSectors++;

    }

    function getSectorName(uint256 _sectorID) public view returns (string memory){
        return s.sectors[_sectorID].sectorName;
    }
    
}