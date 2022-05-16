// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./ProposalFacet.sol/";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

import '@openzeppelin/contracts/access/Ownable.sol';

contract TreasuryFacet is Ownable {

  AppStorage internal s;

  address public owner;

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  EVENTS        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  event PhaseOnePaid(uint256 amount, uint256 time);
  event PhaseOneClosed();
  event PhaseTwoPaid(uint256 amount, uint256 time);
  event PhaseTwoClosed();
  event PhaseThreePaid(uint256 amount, uint256 time);
  event PhaseThreeClosed();
  event PhaseFourPaid(uint256 amount, uint256 time);
  event PhaseFourClosed();

   //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  CONSTRUCTOR         ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  constructor (address _USDC) {
    s.USDAddress = _USDC;
    owner = msg.sender;
  }


    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         GENERAL FUNCTIONALITY        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function payPhaseOne() external onlyAdmin {
    require(tenderState == DEVELOPMENT, "NOT DEVELOPMENT");

    emit PhaseOnePaid(_amount, uint256 block.timestamp);
  }

  function closePhaseOne() external onlySupervisor {
    s.tenderPhase = TWO;
  }

  function payPhaseTwo() external onlyAdmin {
    require(s.tenderState == DEVELOPMENT, "NOT DEVELOPMENT");
    require(s.tenderPhase == TWO, "STILL IN PHASE ONE");

    emit PhaseTwoPaid(_amount, uint256 block.timestamp);
  }

  function closePhaseTwo() external onlySupervisor {
    s.tenderPhase = THREE;
  }

  function payPhaseThree() external onlyAdmin {
    require(s.tenderState == DEVELOPMENT, "NOT DEVELOPMENT");
    require(s.tenderPhase == THREE, "STILL IN PHASE TWO");

    emit PhaseThreePaid(_amount, uint256 block.timestamp);
  }

  function closePhaseThree() external onlySupervisor {
    s.tenderPhase = FOUR;
  }

  function payPhaseFour() external onlyAdmin {
    require(s.tenderState == DEVELOPMENT, "NOT DEVELOPMENT");
    require(s.tenderPhase == FOUR, "STILL IN PHASE THREE");

    emit PhaseFourPaid(_amount, uint256 block.timestamp);
  }

  function closePhaseFour() external onlySupervisor {
    s.tenderState = CLOSED;
  }

  function setSupervisor(address supervisor) internal onlyOwner {
    s.supervisors[supervisor] = true;
  } 
}