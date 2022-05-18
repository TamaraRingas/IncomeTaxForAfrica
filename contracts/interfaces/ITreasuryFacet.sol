// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../libraries/AppStorage.sol";

interface ITreasuryFacet {
  
    function getProposalStateDetails(uint256 _proposalID) external;
}