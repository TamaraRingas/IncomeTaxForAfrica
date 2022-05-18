// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ISectorFacet.sol";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

contract SectorFacet is ISectorFacet, Modifiers {

    //AppStorage internal s;

    constructor() {
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
    
}