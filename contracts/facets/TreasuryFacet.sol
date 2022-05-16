// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./ProposalFacet.sol/";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TreasuryFacet is Ownable, Modifiers, ReentrancyGuard {

  AppStorage internal s;

  address public owner;

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  EVENTS        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  event PhaseOnePaid(Proposal proposal, uint256 amount, uint256 time);
  event PhaseTwoApproved(Proposal proposal);

  event PhaseTwoPaid(Proposal proposal, uint256 amount, uint256 time);
  event PhaseThreeApproved(Proposal proposal);

  event PhaseThreePaid(Proposal proposal, uint256 amount, uint256 time);
  event PhaseFourApproved(Proposal proposal);

  event PhaseFourPaid(Proposal proposal, uint256 amount, uint256 time);
  event ProposalClosed(Proposal proposal);

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

  function payPhaseOne(Proposal _proposal) external onlySupervisor {
    require(_proposal._proposalState == PHASE_1, "NOT PHASE_1");

    emit PhaseOnePaid(_proposal, _amount, block.timestamp);
  }

  function closePhaseOne(Proposal _proposal) external onlySupervisor {
    s.tenderPhase = PHASE_2;
  }

  function payPhaseTwo(Proposal _proposal) external onlySupervisor {
    require(s.tenderPhase == PHASE_2, "STILL IN PHASE ONE");

    emit PhaseTwoPaid(_proposal, _amount, block.timestamp);
  }

  function closePhaseTwo(Proposal _proposal) external onlySupervisor {
    s.tenderPhase = PHASE_3;
  }

  function payPhaseThree(Proposal _proposal) external onlySupervisor {
    require(s.tenderPhase == PHASE_3, "STILL IN PHASE TWO");

    emit PhaseThreePaid(_proposal, _amount, block.timestamp);
  }

  function closePhaseThree(Proposal _proposal) external onlySupervisor {
    s.tenderPhase = PHASE_4;
  }

  function payPhaseFour(Proposal _proposal) external onlySupervisor {
    require(s.tenderPhase == PHASE_4, "STILL IN PHASE THREE");

    emit PhaseFourPaid(_proposal, _amount, block.timestamp);
  }

  function closePhaseFour(Proposal _proposal) external onlySupervisor {
    s.tenderState = CLOSED;
  }
}