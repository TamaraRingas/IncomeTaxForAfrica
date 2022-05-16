// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../interfaces/IProposalFacet.sol";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

contract ProposalFacet is IProposalFacet, Modifiers {

    event createProposal(Proposal _proposal);

    constructor() {

    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         CREATE FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function createProposal(Proposal memory _proposal) public {

        _proposal.numberOfPublicVotes = 0;
        _proposal.proposalID = s.numberOfProposals;
        _proposal.numberOfGovernmentVotes = 0;
        _proposal.storageHash = "";
        _proposal._proposalState = ProposalState.PROPOSED;

        s.proposals[s.numberOfProposals] = _proposal;

        s.numberOfProposals++;

        emit ProposalCreated(s.proposals[s.numberOfProposals - 1]);

    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         GENERAL FUNCTIONALITY        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function voteForProposal(uint256 _proposalID, uint256 _citizenID) public onlyCitizen(_citizenID) {
        require(
            s.proposals[_proposalID]._proposalState == ProposalState.PROPOSED,
            "PROPOSAL CLOSED"
        );

        require(s.citizens[_citizenID].taxPercentage >= 0, "NOT A TAX PAYER");

        uint256 citizenVotePower = s.citizens[_citizenID].taxPercentage;

        s.proposals[_proposalID].numberOfPublicVotes += citizenVotePower;
        
        s.citizens[_citizenID].totalPriorityPoints -= tenderPriorityPoints;
        s.tenders[_tenderID].numberOfVotes++;

        emit VoteSubmitted(msg.sender, _tenderID, s.tenders[_tenderID].numberOfVotes);
        
    }

}