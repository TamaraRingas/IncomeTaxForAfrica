// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./ProposalFacet.sol";
import "../interfaces/ITreasuryFacet.sol";
import { AppStorage } from "../libraries/AppStorage.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TreasuryFacet is ITreasuryFacet, Ownable, ReentrancyGuard {

  AppStorage internal s;

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
    s.USDC = IERC20(_USDC);
    s.TreasuryAddress = address(this);
  }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         VIEW FUNCTIONALITY       ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function getProposalStateDetails(uint256 _proposalID) external view returns (ProposalState) {
    return s.proposals[_proposalID]._proposalState;
  }

  function getTreasuryBalance() external view onlyOwner returns (uint256) {
    return s.treasuryBalance;
  }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         ONLY SUPERVISOR FUNCTIONALITY        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function payPhaseOne(uint256 _proposalID) external onlySupervisor(_proposalID) nonReentrant {
    require(s.proposals[_proposalID]._proposalState == ProposalState.PHASE_1, "NOT PHASE_1");
    
    s.treasuryBalance -= s.proposals[_proposalID].priceCharged/4;

    s.USDC.transfer(s.companies[s.proposals[_proposalID].companyID].wallet, s.proposals[_proposalID].priceCharged/4);

    emit PhaseOnePaid(_proposalID, s.proposals[_proposalID].priceCharged/4, block.timestamp);
  }

  function closePhaseOne(uint256 _proposalID) external onlySupervisor(_proposalID) {
    s.proposals[_proposalID]._proposalState = ProposalState.PHASE_2;
  }

  function payPhaseTwo(uint256 _proposalID) external onlySupervisor(_proposalID) nonReentrant{
    require(s.proposals[_proposalID]._proposalState == ProposalState.PHASE_2, "STILL IN PHASE ONE");

    s.treasuryBalance -= s.proposals[_proposalID].priceCharged/4;
    
    s.USDC.transfer(s.companies[s.proposals[_proposalID].companyID].wallet, s.proposals[_proposalID].priceCharged/4);

    emit PhaseTwoPaid(_proposalID, s.proposals[_proposalID].priceCharged/4, block.timestamp);
  }

  function closePhaseTwo(uint256 _proposalID) external onlySupervisor(_proposalID) {
    s.proposals[_proposalID]._proposalState = ProposalState.PHASE_3;
  }

  function payPhaseThree(uint256 _proposalID) external onlySupervisor(_proposalID) nonReentrant {
    require(s.proposals[_proposalID]._proposalState == ProposalState.PHASE_3, "STILL IN PHASE TWO");
        
    s.treasuryBalance -= s.proposals[_proposalID].priceCharged/4;

    s.USDC.transfer(s.companies[s.proposals[_proposalID].companyID].wallet, s.proposals[_proposalID].priceCharged/4);

    emit PhaseThreePaid(_proposalID, s.proposals[_proposalID].priceCharged/4, block.timestamp);
  }

  function closePhaseThree(uint256 _proposalID) external onlySupervisor(_proposalID) {
    s.proposals[_proposalID]._proposalState = ProposalState.PHASE_4;
  }

  function payPhaseFour(uint256 _proposalID) external onlySupervisor(_proposalID) nonReentrant{
    require(s.proposals[_proposalID]._proposalState == ProposalState.PHASE_4, "STILL IN PHASE THREE");

    s.treasuryBalance -= s.proposals[_proposalID].priceCharged/4;

    s.USDC.transfer(s.companies[s.proposals[_proposalID].companyID].wallet, s.proposals[_proposalID].priceCharged/4);

    emit PhaseFourPaid(_proposalID, s.proposals[_proposalID].priceCharged/4, block.timestamp);
  }

  function closePhaseFour(uint256 _proposalID) external onlySupervisor(_proposalID) {
    s.proposals[_proposalID]._proposalState = ProposalState.CLOSED;
  }

   modifier onlyAdmin(uint256 _tenderID) {
        require(msg.sender == s.tenders[_tenderID].admin, "ONLY ADMIN");
        _;
    }

    modifier onlySuperAdmin() {
        require(msg.sender == s.superAdmin, "ONLY SUPER ADMIN");
        _;
    }

    modifier onlySupervisor(uint256 _proposalID) {
        require(msg.sender == s.proposals[_proposalID].supervisor, "ONLY SUPERVISOR");
        _;
    }

    modifier onlySectorAdmins(uint256 _sectorID) {
        require(s.sectors[_sectorID].sectorAdmins[msg.sender] == true, "ONLY SECTOR ADMINS");
        _;
    }

     modifier onlyCompanyAdmin(uint256 _companyID) {
        require(msg.sender == s.companies[_companyID].admin, "ONLY COMPANY ADMIN");
        _;
    }
}