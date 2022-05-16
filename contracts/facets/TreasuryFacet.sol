// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./ProposalFacet.sol/";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

import '@openzeppelin/contracts/access/Ownable.sol';

contract TreasuryFacet is Ownable {

  AppStorage internal s;

  address public owner;

  // ------------------------------------------ //
	//                  EVENTS                    //
	// ------------------------------------------ //

  event PhaseOnePaid(uint256 amount, uint256 time);
  event PhaseOneClosed();
  event PhaseTwoPaid(uint256 amount, uint256 time);
  event PhaseTwoClosed();
  event PhaseThreePaid(uint256 amount, uint256 time);
  event PhaseThreeClosed();
  event PhaseFourPaid(uint256 amount, uint256 time);
  event PhaseFourClosed();

  // ------------------------------------------ //
	//                 CONSTRUCTOR                //
	// ------------------------------------------ //

  constructor (address _USDC) {
    s.USDAddress = _USDC;
    owner = msg.sender;
  }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         GENERAL FUNCTIONALITY        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function payPhaseOne() external onlyAdmin {
    require(tenderState == DEVELOPMENT, "NOT DEVELOPMENT");

  }

  function closePhaseOne() external onlySupervisor {
    
  }

  function payPhaseTwo() external onlyAdmin {
    require(tenderState == DEVELOPMENT, "NOT DEVELOPMENT");
  }

  function closePhaseTwo() external onlySupervisor {

  }

  function payPhaseThree() external onlyAdmin {
    require(tenderState == DEVELOPMENT, "NOT DEVELOPMENT");
  }

  function closePhaseThree() external onlySupervisor {
    
  }

  function payPhaseFour() external onlyAdmin {
    require(tenderState == DEVELOPMENT, "NOT DEVELOPMENT");
  }

  function closePhaseFour() external onlySupervisor {
    s.tenderState = CLOSED;
  }

  function setSupervisor(address supervisor) internal onlyOwner {
    s.supervisors[supervisor] = true;
  }

  
  
}