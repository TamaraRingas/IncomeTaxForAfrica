// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ISector.sol";
import "hardhat/console.sol";

contract Sector is ISector {

    uint256 numberOfSectors;

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

     modifier onlyAdmin(uint256 _tenderID) {
        require(msg.sender == tenders[_tenderID].admin, "ONLY ADMIN");
        _;
    }

    modifier onlySuperAdmin() {
        require(msg.sender == superAdmin, "ONLY SUPER ADMIN");
        _;
    }

    modifier onlySupervisor(uint256 _proposalID) {
        require(msg.sender == proposals[_proposalID].supervisor, "ONLY SUPERVISOR");
        _;
    }

    modifier onlySectorAdmins(uint256 _sectorID) {
        require(sectors[_sectorID].sectorAdmins[msg.sender] == true, "ONLY SECTOR ADMINS");
        _;
    }

     modifier onlyCompanyAdmin(uint256 _companyID) {
        require(msg.sender == companies[_companyID].admin, "ONLY COMPANY ADMIN");
        _;
    }
    
}