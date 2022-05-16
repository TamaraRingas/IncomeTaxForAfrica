// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/IProposalFacet.sol";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

contract ProposalFacet is IProposalFacet, Modifiers {

    AppStorage internal s;

    address public owner;

    event ProposalCreated(Proposal _proposal);

    constructor() {
        owner = msg.sender;
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

        s.companies[_proposal.companyID].currentProposals.push(_proposal);

        emit ProposalCreated(s.proposals[s.numberOfProposals - 1]);

    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         GENERAL FUNCTIONALITY        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function voteForProposal(uint256 _proposalID) public onlyCitizen(_citizenID) {
        
        uint256 _citizenID = s.userAddressesToIDs[msg.sender];
        
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

    //Total public votes is scale of 10_000
    //Incase of ties, cheaper price quoted will be selected
    function calculateWinningProposals(uint256 _tenderID) public {
        
        uint256 winningNumberOfVotes = 0;
        uint256 winningBudget = 0;
        Proposal winningProposal;

        for(int x = 0; x <= s.numberOfProposals; x++) {
            if(s.proposals[x].tenderID == _tenderID) {
                if(s.proposals[x].numberOfPublicVotes = winningNumberOfVotes) {
                    if(s.proposals[x].priceCharged < winningBudget) {    
                        winningNumberOfVotes = s.proposals[x].numberOfPublicVotes;
                        winningProposal = s.proposals[x];
                    }
                } else if(s.proposals[x].numberOfPublicVotes > winningNumberOfVotes) {
                    winningNumberOfVotes = s.proposals[x].numberOfPublicVotes;
                    winningProposal = s.proposals[x];
                }
            }
        }

        winningProposal._proposalState = ProposalState.SUCCESSFULL;

        for(int x = 0; x < s.numberOfProposals; x++){
            if(s.proposals[x].tenderID == _tenderID) {
                if(s.proposals[x].proposalID != winningProposal.proposalID) {
                    s.proposals[x]._proposalState = ProposalState.UNSUCCESSFULL;
                }   
            }
        }
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         VIEW FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------


    function viewAllProposals() public view returns (Proposal[] memory) {
        
        Proposal[] memory tempProposal = new Tender[](s.numberOfProposals);

        for (uint256 i = 0; i < s.numberOfProposals; i++) {
            tempProposal[i] = s.proposals[i];
        }

        return tempProposal;
    }

    function getProposal(uint256 _proposalID) public view returns (Proposal memory){
        return s.proposals[_proposalID];
    }

}