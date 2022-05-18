// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ICitizenFacet.sol";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

contract CitizenFacet is ICitizenFacet, Modifiers {

    event SectorsSelected(uint256 _citizenID, uint256 _primarySector, uint256 _secondarySector);
    event CitizenRegistered(uint256 _citizenID, uint256 _numberOfCitizens);

    constructor() {
    }

    function selectSectors(uint256 _citizenID, uint256 _primarySectorID, uint256 _secondarySectorID) public {

        require(_primarySectorID != _secondarySectorID, "SECTORS CANNOT BE THE SAME");
        require(_primarySectorID < s.numberOfSectors, "INVALID PRIMARY SECTOR ID");
        require(_secondarySectorID < s.numberOfSectors, "INVALID SECONDARY SECTOR ID");
        require(_citizenID == s.userAddressesToIDs[msg.sender], "CAN ONLY UPDATE OWN SETTINGS");

        s.citizens[_citizenID].primarySectorID = _primarySectorID;
        s.citizens[_citizenID].secondarySectorID = _secondarySectorID;

        emit SectorsSelected(_citizenID, s.citizens[_citizenID].primarySectorID, s.citizens[_citizenID].secondarySectorID);

    }

    function register(Citizen memory _citizen) public onlySuperAdmin() {
        //Check they are a SA citizen through chainlink

        _citizen.citizenID = s.numberOfCitizens;
        _citizen.taxPercentage = 0;
        _citizen.totalTaxPaid = 0;
        _citizen.totalPriorityPoints = 0;
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
    
}