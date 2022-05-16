// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract GovernanceFacet is Ownable {

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


  function setSectorAdmin() external onlyOwner {
    
  }

  function setSupervisor(address supervisor) internal onlyOwner {
    s.supervisors[supervisor] = true;
  } 

  function removeSupervisor(address supervisor) internal onlyOwner {
    s.supervisors[supervisor] = false;
  } 

  
  
}