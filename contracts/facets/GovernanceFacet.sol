// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

contract GovernanceFacet is Ownable {

  AppStorage internal s;


  function setSectorAdmin() is onlyOwner {
    
  }
  
}