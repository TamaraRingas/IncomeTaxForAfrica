// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../interfaces/IProposalFacet.sol";

contract ProposalFacet is IProposalFacet {

    enum ProposalState {
        PROPOSED,
        UNSUCCESSFULL,
        SUCCESSFULL,
        PHASE_1,
        PHASE_2,
        PHASE_3,
        PHASE_4,
        CLOSED
    }

}