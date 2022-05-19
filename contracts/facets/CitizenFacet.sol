// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ICitizenFacet.sol";
import { AppStorage} from "../libraries/AppStorage.sol";
import "hardhat/console.sol";

contract CitizenFacet is ICitizenFacet{

    uint256 numberOfCitizens;

    struct Citizen {
    uint256 citizenID;
    uint256 salary;

    //Stored out of 10_000 for scale
    uint256 taxPercentage;
    uint256 primarySectorID;
    uint256 secondarySectorID;
    uint256 totalTaxPaid;

    //Total taxPaid / 1000
    uint256 totalPriorityPoints;
    address walletAddress;
    string firstName;
    string secondName;
    }

    mapping(uint256 => Citizen) citizens;

    //Mapping of citizen addresses => id's
    mapping(address => uint256) userAddressesToIDs;

    event SectorsSelected(uint256 _citizenID, uint256 _primarySector, uint256 _secondarySector);
    event CitizenRegistered(uint256 _citizenID, uint256 _numberOfCitizens);

    constructor() {
        s.superAdmin = msg.sender;
    }

    function selectSectors(uint256 _citizenID, uint256 _primarySectorID, uint256 _secondarySectorID) public {

        console.log(s.numberOfSectors);

        require(_primarySectorID != _secondarySectorID, "SECTORS CANNOT BE THE SAME");
        require(_primarySectorID <= s.numberOfSectors, "INVALID PRIMARY SECTOR ID");
        require(_secondarySectorID <= s.numberOfSectors, "INVALID SECONDARY SECTOR ID");
        require(_citizenID == s.userAddressesToIDs[msg.sender], "CAN ONLY UPDATE OWN SETTINGS");

        s.citizens[_citizenID].primarySectorID = _primarySectorID;
        s.citizens[_citizenID].secondarySectorID = _secondarySectorID;

        emit SectorsSelected(_citizenID, s.citizens[_citizenID].primarySectorID, s.citizens[_citizenID].secondarySectorID);

    }

    function register(Citizen memory _citizen) public {
        //Check they are a SA citizen through chainlink

        console.log(s.numberOfTenders);

        _citizen.citizenID = s.numberOfCitizens;
        _citizen.taxPercentage = 0;
        _citizen.totalTaxPaid = 0;
        _citizen.totalPriorityPoints = 20;
        _citizen.salary = 0;
        _citizen.walletAddress = msg.sender;

        s.citizens[s.numberOfCitizens] = _citizen;
        s.userAddressesToIDs[msg.sender] = s.numberOfCitizens;
        s.numberOfCitizens++;


        emit CitizenRegistered(_citizen.citizenID, s.numberOfCitizens);

    }

    function getCitizenPrimaryID(uint256 _citizenID) public view returns (uint256){
        return s.citizens[_citizenID].primarySectorID;
    }

    function getCitizenSecondaryID(uint256 _citizenID) public view returns (uint256){
        return s.citizens[_citizenID].secondarySectorID;
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