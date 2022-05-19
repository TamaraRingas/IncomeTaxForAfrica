// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

interface ITenderFacet {

    function createTender(Tender memory _tender) external;

    function viewAllTenders() external view returns (Tender[] calldata);

    function getTender(uint256 _tenderID) external view returns (Tender calldata);

    function voteForTender(uint256 _tenderID, uint256 _citizenID) external;

    function closeVoting(uint256 _tenderID) external;

    function setThreshold(uint256 _threshold, uint256 _tenderID) external;

    function closeTender(uint256 _tenderID) external;

    function openProposals(uint256 _tenderID) external;

    function closeProposals(uint256 _tenderID) external;

    function closeProposalVoting(uint256 _tenderID) external;

    function openProjectDevelopment(uint256 _tenderID) external;

    function closeProjectDevelopment(uint256 _tenderID) external;


    
}