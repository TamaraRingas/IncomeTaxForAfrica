// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ISector.sol";
import "hardhat/console.sol";

contract SectorFacet is ISector {

    uint256 numberOfSectors;
    
    struct Sector {
    uint256 sectorID;
    uint256 numberOfTenders;
    uint256 currentFunds;
    uint256 budget;
    string sectorName;
    bool budgetReached;
    mapping(address => bool) sectorAdmins;
    }

    mapping(uint256 => Sector) sectors;

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

        console.log(s.sectors[s.numberOfSectors - 1].sectorID);

    }

    function getSectorName(uint256 _sectorID) public view returns (string memory){
        return s.sectors[_sectorID].sectorName;
    }

     modifier onlyAdmin(uint256 _tenderID) {
        require(msg.sender == s.tenders[_tenderID].admin, "ONLY ADMIN");
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