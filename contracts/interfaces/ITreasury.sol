// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;



interface ITreasuryFacet {

  function getProposalStateDetails(uint256 _proposalID) external view returns (ProposalState);

  function getTreasuryBalance() external view returns (uint256);

  function payPhaseOne(uint256 _proposalID) external;

  function closePhaseOne(uint256 _proposalID) external;

  function payPhaseTwo(uint256 _proposalID) external;

  function closePhaseTwo(uint256 _proposalID) external;

  function payPhaseThree(uint256 _proposalID) external;

  function closePhaseThree(uint256 _proposalID) external;

  function payPhaseFour(uint256 _proposalID) external;

  function closePhaseFour(uint256 _proposalID) external;

}