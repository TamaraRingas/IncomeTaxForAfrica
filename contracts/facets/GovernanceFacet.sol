// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "..//interfaces/IGovernanceFacet.sol";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract GovernanceFacet is IGovernanceFacet, Ownable, Modifiers {

  //AppStorage internal s;

   //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  EVENTS        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  event SetSuperAdmin(address previousSuperAdmin, address newAdmin, uint256 time);
  event SetTenderAdmin(uint256 tenderID,address previousAdmin, address newAdmin, uint256 time);
  event SetSectorAdmin(uint256 sectorID, address newAdmin, uint256 time);
  event ChangeCompanyAdmin(uint256 companyID,address previousAdmin, address newAdmin, uint256 time);
  event SetSupervisor(uint256 proposalID,address previousSupervisor, address newSupervisor, uint256 time);

   //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  FUNCTIONS       ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function setSuperAdmin(address _newSuperAdmin) public onlySuperAdmin(s.superAdmin){
        require(_newSuperAdmin != address(0), "CANNOT BE ZERO ADDRESS");

        address previousSuperAdmin = s.superAdmin;

        s.superAdmin = _newSuperAdmin;

        emit SetSuperAdmin(previousSuperAdmin, s.superAdmin, block.timestamp);
  }

  function setTenderAdmin(uint256 _tenderID, address _admin) public onlySuperAdmin(s.superAdmin){
        require(_admin != address(0), "CANNOT BE ZERO ADDRESS");

        address previousAdmin =  s.tenders[_tenderID].admin;

        s.tenders[_tenderID].admin = _admin;

        emit SetTenderAdmin(_tenderID, previousAdmin, s.tenders[_tenderID].admin, block.timestamp);
  }


  function setSectorAdmin(uint256 _sectorID, address _newAdmin) public onlyOwner {
    require(_newAdmin != address(0), "CANNOT BE ZERO ADDRESS");

    s.sectors[_sectorID].sectorAdmins[_newAdmin] = true; 

    emit SetSectorAdmin(_sectorID, _newAdmin, block.timestamp);
  }

  function changeCompanyAdmin(uint256 _companyID, address _newAdmin) public onlyAdmin (_companyID) {
        require(_newAdmin != address(0), "CANNOT BE ZERO ADDRESS");
        require(_companyID <= s.numberOfCompanies, "NOT A VALID COMPANY ID");

        address previousAdmin =  s.companies[_companyID].admin;
        s.companies[_companyID].admin = _newAdmin;

        emit ChangeCompanyAdmin(_companyID, previousAdmin, s.companies[_companyID].admin, block.timestamp);
  }
  
  function setSupervisor(uint256 _proposalID, address _newSupervisor) public onlySupervisor(_proposalID) {
    require(_newSupervisor != address(0), "CANNOT BE ZERO ADDRESS");
    require(_proposalID <= s.numberOfProposals, "NOT A VALID COMPANY ID");

    address previousSupervisor =  s.proposals[_proposalID].supervisor;

    s.proposals[_proposalID].supervisor = _newSupervisor;

    emit SetSupervisor(_proposalID, previousSupervisor, _newSupervisor, block.timestamp);
  } 
}