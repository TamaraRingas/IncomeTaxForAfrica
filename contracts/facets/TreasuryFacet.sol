// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./ProposalFacet.sol/";
import "..//interfaces/ITreasuryFacet.sol";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TreasuryFacet is ITreasuryFacet, Ownable, Modifiers, ReentrancyGuard {

  AppStorage internal s;

  address public owner;

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  EVENTS        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  event PhaseOnePaid(uint256 proposalID, uint256 amount, uint256 time);
  event PhaseTwoApproved(uint256 proposalID);

  event PhaseTwoPaid(uint256 proposalID, uint256 amount, uint256 time);
  event PhaseThreeApproved(uint256 proposalID);

  event PhaseThreePaid(uint256 proposalID, uint256 amount, uint256 time);
  event PhaseFourApproved(uint256 proposalID);

  event PhaseFourPaid(uint256 proposalID, uint256 amount, uint256 time);
  event ProposalClosed(uint256 proposalID);

   //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  CONSTRUCTOR         ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  constructor (address _USDC) {
    s.USDAddress = _USDC;
  }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         VIEW FUNCTIONALITY       ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function getProposalStateDetails(Proposal _proposal) external view returns (string) {
    return _proposal._proposalState;
  }

  function getTreasuryBalance() external view onlyOwner returns (uint256) {
    return s.treasuryBalance;
  }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         ONLY SUPERVISOR FUNCTIONALITY        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function payPhaseOne(uint256 _proposalID) external onlySupervisor(_proposalID)nonReentrant {
    require(s.proposals[_proposalID]._proposalState == PHASE_1, "NOT PHASE_1");
    
    s.USDAddress.transfer(s.companies[s.proposals[_proposalID].companyID].wallet, s.proposals[_proposalID].priceCharged/4);

    s.companies[s.proposals[_proposalID].companyID].balance() += s.proposals[_proposalID].priceCharged/4;

    s.treasuryBalance -= s.proposals[_proposalID].priceCharged/4;

    emit PhaseOnePaid(_proposal, _amount, block.timestamp);
  }

  function closePhaseOne(uint256 _proposalID) external onlySupervisor(_proposalID) {
    s.proposals[_proposalID]._proposalState = PHASE_2;
  }

  function payPhaseTwo(uint256 _proposalID) external onlySupervisor() nonReentrant{
    require(s.proposals[_proposalID]._proposalState == PHASE_2, "STILL IN PHASE ONE");

    s.USDAddress.transfer(s.companies[s.proposals[_proposalID].companyID].wallet, s.proposals[_proposalID].priceCharged/4);

    s.companies[s.proposals[_proposalID].companyID].balance() += s.proposals[_proposalID].priceCharged/4;

    s.treasuryBalance -= s.proposals[_proposalID].priceCharged/4;

    emit PhaseTwoPaid(_proposal, _amount, block.timestamp);
  }

  function closePhaseTwo(uint256 _proposalID) external onlySupervisor(_proposalID) {
    s.proposals[_proposalID]._proposalState = PHASE_3;
  }

  function payPhaseThree(uint256 _proposalID) external onlySupervisor(_proposalID) nonReentrant {
    require(s.proposals[_proposalID]._proposalState == PHASE_3, "STILL IN PHASE TWO");

    s.USDAddress.transfer(s.companies[s.proposals[_proposalID].companyID].wallet, s.proposals[_proposalID].priceCharged/4);

    s.companies[s.proposals[_proposalID].companyID].balance() += s.proposals[_proposalID].priceCharged/4;

    s.treasuryBalance -= s.proposals[_proposalID].priceCharged/4;

    emit PhaseThreePaid(_proposal, _amount, block.timestamp);
  }

  function closePhaseThree(uint256 _proposalID) external onlySupervisor(_proposalID) {
    s.proposals[_proposalID]._proposalState = PHASE_4;
  }

  function payPhaseFour(Proposal _proposal) external onlySupervisor(_proposalID) nonReentrant{
    require(s.proposals[_proposalID]._proposalState == PHASE_4, "STILL IN PHASE THREE");

    s.USDAddress.transfer(s.companies[s.proposals[_proposalID].companyID].wallet, s.proposals[_proposalID].priceCharged/4);

    s.companies[s.proposals[_proposalID].companyID].balance() += s.proposals[_proposalID].priceCharged/4;

    s.treasuryBalance -= s.proposals[_proposalID].priceCharged/4;

    emit PhaseFourPaid(_proposal, _amount, block.timestamp);
  }

  function closePhaseFour(uint256 _proposalID) external onlySupervisor(_proposalID) {
    s.proposals[_proposalID]._proposalState = CLOSED;
  }
}