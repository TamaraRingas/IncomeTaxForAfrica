// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ISector.sol";
import "./Tender.sol";
import "./Governance.sol";
import "hardhat/console.sol";

contract Sector is ISector {

    uint256 public numberOfSectors;

    mapping(uint256 => Sector) sectors;

    // constructor() {
    //     superAdmin = msg.sender;
    // }

    function createSector(string memory _name) public onlySuperAdmin(){

        Sector storage _sector = sectors[numberOfSectors];

       _sector.sectorID = numberOfSectors;
       _sector.numberOfTenders = 0;
       _sector.currentFunds = 0;
       _sector.budget = 0;
       _sector.budgetReached = false;
       _sector.sectorName = _name;

        numberOfSectors++;

        console.log(sectors[numberOfSectors - 1].sectorID);

    }

    function getSectorName(uint256 _sectorID) public view returns (string memory){
        return sectors[_sectorID].sectorName;
    }

    modifier onlySuperAdmin() {
        require(msg.sender == superAdmin, "ONLY SUPER ADMIN");
        _;
    }
}