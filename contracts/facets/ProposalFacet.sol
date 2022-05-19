// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/IProposalFacet.sol";
import { AppStorage } from "../libraries/AppStorage.sol";

contract ProposalFacet is IProposalFacet {

    address public owner;

    struct Proposal {
    uint256 proposalID;
    uint256 tenderID;
    uint256 sectorID;
    uint256 companyID;
    uint256 priceCharged;
    uint256 numberOfPublicVotes;
    address supervisor;
    string storageHash;
    ProposalState _proposalState;
    }

    event ProposalCreated(Proposal _proposal);

    constructor() {
        owner = msg.sender;
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         CREATE FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function createProposal(Proposal memory _proposal, address _supervisor) public {

        _proposal.numberOfPublicVotes = 0;
        _proposal.proposalID = s.numberOfProposals;
        _proposal.storageHash = "";
        _proposal._proposalState = ProposalState.PROPOSED;
        
        _proposal.supervisor = _supervisor;

        s.proposals[s.numberOfProposals] = _proposal;

        s.numberOfProposals++;

        s.companies[_proposal.companyID].currentProposals[s.numberOfProposals - 1] = _proposal;

        emit ProposalCreated(s.proposals[s.numberOfProposals - 1]);

    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         GENERAL FUNCTIONALITY        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function voteForProposal(uint256 _proposalID) public onlyCitizen(msg.sender) {
        
        uint256 _citizenID = s.userAddressesToIDs[msg.sender];
        
        require(
            s.proposals[_proposalID]._proposalState == ProposalState.PROPOSED,
            "PROPOSAL CLOSED"
        );

        require(s.citizens[_citizenID].taxPercentage >= 0, "NOT A TAX PAYER");

        uint256 citizenVotePower = s.citizens[_citizenID].taxPercentage;

        s.proposals[_proposalID].numberOfPublicVotes += citizenVotePower;
        
    }

    //Total public votes is scale of 10_000
    //Incase of ties, cheaper price quoted will be selected
    function calculateWinningProposals(uint256 _tenderID) public {
        
        uint256 winningNumberOfVotes = 0;
        uint256 winningBudget = 0;
        Proposal memory winningProposal;

        for(uint256 x = 0; x <= s.numberOfProposals; x++) {
            if(s.proposals[x].tenderID == _tenderID) {
                if(s.proposals[x].numberOfPublicVotes == winningNumberOfVotes) {
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

        for(uint256 x = 0; x < s.numberOfProposals; x++){
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
        
        Proposal[] memory tempProposal = new Proposal[](s.numberOfProposals);

        for (uint256 i = 0; i < s.numberOfProposals; i++) {
            tempProposal[i] = s.proposals[i];
        }

        return tempProposal;
    }

    function getProposal(uint256 _proposalID) public view returns (Proposal memory) {
        return s.proposals[_proposalID];
    }

    modifier onlyCitizen(address citizen) {
        uint256 _citizenID = s.userAddressesToIDs[msg.sender];
        require(_citizenID <= s.numberOfCitizens, "ONLY CITIZENS");
        _;
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