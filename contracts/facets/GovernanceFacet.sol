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

  event SetSuperAdmin(address previousSuperAdmin, address newAdmin);
  event SetTenderAdmin(uint256 tenderID,address previousAdmin, address newAdmin);
  event SetSectorAdmin(uint256 sectorID,address previousAdmin, address newAdmin);
  event ChangeCompanyAdmin(uint256 companyID,address previousAdmin, address newAdmin);
  event SetSupervisor(uint256 proposalID,address previousSupervisor, address newSupervisor);


  function setSuperAdmin(address _newSuperAdmin) public onlySuperAdmin(s.superAdmin){
        require(_newSuperAdmin != address(0), "CANNOT BE ZERO ADDRESS");

        address previousSuperAdmin = s.superAdmin;

        s.superAdmin = _newSuperAdmin;

        emit SetSuperAdmin(previousSuperAdmin, s.superAdmin);
  }

  function setTenderAdmin(uint256 _tenderID, address _admin) public onlySuperAdmin(s.superAdmin){
        require(_admin != address(0), "CANNOT BE ZERO ADDRESS");

        address previousAdmin =  s.tenders[_tenderID].admin;

        s.tenders[_tenderID].admin = _admin;

        emit SetTenderAdmin(_tenderID, previousAdmin, s.tenders[_tenderID].admin);
  }


  function setSectorAdmin(uint256 _sectorID, address _newAdmin) external onlyOwner {
    require(_newAdmin != address(0), "CANNOT BE ZERO ADDRESS");

    emit SetSectorAdmin();
  }

  function changeCompanyAdmin(uint256 _companyID, address _newAdmin) public onlyAdmin (_companyID) {
        require(_newAdmin != address(0), "CANNOT BE ZERO ADDRESS");
        require(_companyID <= s.numberOfCompanies, "NOT A VALID COMPANY ID");

        address previousAdmin =  s.companies[_companyID].admin;
        s.companies[_companyID].admin = _newAdmin;

        emit ChangeCompanyAdmin(_companyID, previousAdmin, s.companies[_companyID].admin);
  }
  
  // function addSupervisor(address supervisor) internal onlySupervisor {
  //   s.supervisors[supervisor] = true;
  // } 

  // function removeSupervisor(address supervisor) internal onlyOwner {
  //   s.supervisors[supervisor] = false;
  // } 

  
  
}