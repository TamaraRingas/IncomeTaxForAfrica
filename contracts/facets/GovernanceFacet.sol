// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "..//interfaces/IGovernanceFacet.sol";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract GovernanceFacet is IGovernanceFacet, Ownable, Modifiers {

  AppStorage internal s;

  //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  EVENTS        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function setSuperAdmin(address _newSuperAdmin) public onlySuperAdmin(s.superAdmin){
        require(_newSuperAdmin != address(0), "CANNOT BE ZERO ADDRESS");

        address previousSuperAdmin = s.superAdmin;

        s.superAdmin = _newSuperAdmin;

        emit UpdateSuperAdmin(previousSuperAdmin, s.superAdmin);
  }

  function setTenderAdmin(uint256 _tenderID, address _admin) public onlySuperAdmin(s.superAdmin){
        require(_admin != address(0), "CANNOT BE ZERO ADDRESS");

        address previousAdmin =  s.tenders[_tenderID].admin;

        s.tenders[_tenderID].admin = _admin;

        emit UpdateAdmin(_tenderID, previousAdmin, s.tenders[_tenderID].admin);
  }


  function setSectorAdmin() external onlyOwner {
    
  }

  function changeAdmin(uint256 _companyID, address _newAdmin) public onlyAdmin (_companyID) {
        require(_newAdmin != address(0), "CANNOT BE ZERO ADDRESS");
        require(_companyID <= s.numberOfCompanies, "NOT A VALID COMPANY ID");

        s.companies[_companyID].admin = _newAdmin;
  }

  function addSupervisor(address supervisor) internal onlyOwner {
    s.supervisors[supervisor] = true;
  } 

  function removeSupervisor(address supervisor) internal onlyOwner {
    s.supervisors[supervisor] = false;
  } 

  
  
}