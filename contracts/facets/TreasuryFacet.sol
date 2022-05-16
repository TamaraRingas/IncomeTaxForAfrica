// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./ProposalFacet.sol/";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract TreasuryFacet is Ownable, Modifiers {

  AppStorage internal s;

  address public owner;

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  EVENTS        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  event PhaseOnePaid(uint256 amount, uint256 time);
  event PhaseTwoApproved();
  event PhaseTwoPaid(uint256 amount, uint256 time);
  event PhaseThreeApproved();
  event PhaseThreePaid(uint256 amount, uint256 time);
  event PhaseFourApproved();
  event PhaseFourPaid(uint256 amount, uint256 time);
  event ProposalClosed();

   //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  CONSTRUCTOR         ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  constructor (address _USDC) {
    s.USDAddress = _USDC;
    owner = msg.sender;
  }

  //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         VIEW FUNCTIONALITY       ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function getProposalStateDetails(Proposal _proposal) external view returns (string) {
    return _proposal._proposalState;
  }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         GENERAL FUNCTIONALITY        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function payPhaseOne(Proposal _proposal) external onlyAdmin {
    require(_proposal._proposalState == PHASE_1, "NOT PHASE_1");

    emit PhaseOnePaid(_amount, block.timestamp);
  }

  function closePhaseOne(Proposal _proposal) external onlySupervisor {
    s.tenderPhase = TWO;
  }

  function payPhaseTwo(Proposal _proposal) external onlyAdmin {
    require(s.tenderState == DEVELOPMENT, "NOT DEVELOPMENT");
    require(s.tenderPhase == TWO, "STILL IN PHASE ONE");

    emit PhaseTwoPaid(_amount, block.timestamp);
  }

  function closePhaseTwo(Proposal _proposal) external onlySupervisor {
    s.tenderPhase = THREE;
  }

  function payPhaseThree(Proposal _proposal) external onlyAdmin {
    require(s.tenderState == DEVELOPMENT, "NOT DEVELOPMENT");
    require(s.tenderPhase == THREE, "STILL IN PHASE TWO");

    emit PhaseThreePaid(_amount, block.timestamp);
  }

  function closePhaseThree(Proposal _proposal) external onlySupervisor {
    s.tenderPhase = FOUR;
  }

  function payPhaseFour(Proposal _proposal) external onlyAdmin {
    require(s.tenderState == DEVELOPMENT, "NOT DEVELOPMENT");
    require(s.tenderPhase == FOUR, "STILL IN PHASE THREE");

    emit PhaseFourPaid(_amount, block.timestamp);
  }

  function closePhaseFour(Proposal _proposal) external onlySupervisor {
    s.tenderState = CLOSED;
  }
}