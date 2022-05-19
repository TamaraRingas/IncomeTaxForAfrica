// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ICitizen.sol";
import "./Sector.sol";
import "hardhat/console.sol";

contract Citizen is ICitizen {

    uint256 public numberOfCitizens;

    mapping(uint256 => Citizen) citizens;

    //Mapping of citizen addresses => id's
    mapping(address => uint256) userAddressesToIDs;

    event SectorsSelected(uint256 _citizenID, uint256 _primarySector, uint256 _secondarySector);
    event CitizenRegistered(uint256 _citizenID, uint256 _numberOfCitizens);

    // constructor() {
    //     s.superAdmin = msg.sender;
    // }

    function selectSectors(uint256 _citizenID, uint256 _primarySectorID, uint256 _secondarySectorID) public {

        console.log(numberOfSectors);

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

        console.log(numberOfTenders);

        _citizen.citizenID = numberOfCitizens;
        _citizen.taxPercentage = 0;
        _citizen.totalTaxPaid = 0;
        _citizen.totalPriorityPoints = 20;
        _citizen.salary = 0;
        _citizen.walletAddress = msg.sender;

        citizens[s.numberOfCitizens] = _citizen;
        userAddressesToIDs[msg.sender] = numberOfCitizens;
        numberOfCitizens++;


        emit CitizenRegistered(_citizen.citizenID, numberOfCitizens);

    }

    function getCitizenPrimaryID(uint256 _citizenID) public view returns (uint256){
        return citizens[_citizenID].primarySectorID;
    }

    function getCitizenSecondaryID(uint256 _citizenID) public view returns (uint256){
        return citizens[_citizenID].secondarySectorID;
    }
    
}