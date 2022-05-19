// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

interface IProposal {

    function createProposal(Proposal memory _proposal, address _supervisor) external;

    function voteForProposal(uint256 _proposalID) external;

    function calculateWinningProposals(uint256 _tenderID) external;

    function viewAllProposals() external view returns (Proposal[] memory);

    function getProposal(uint256 _proposalID) external view returns (Proposal memory);


}