// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ITenderFacet.sol";
import "./ProposalFacet.sol";
import { AppStorage, Modifiers } from "../libraries/AppStorage.sol";

contract TenderFacet is ITenderFacet, Modifiers {

    AppStorage internal s;

    address public owner;
    
    ProposalFacet public proposalFacet;

    event TenderCreated(Tender _tender);
    event VoteSubmitted(address _voter, uint256 _tenderVotedFor, uint256 _tendersNumberOfVotes);
    event VoteClosed(uint256 _tenderVoteIsClosedFor);
    event UpdatedThreshold(uint256 _oldValue, uint256 _newValue);
    event TenderClosed(uint256 _tenderThatIsClosed);
    event ProposalOpened(uint256 _tenderProposalOpenFor);
    event ProposalClosed(uint256 _tenderThatProposalIsClosed);
    event ProposalVotingClosed(uint256 _tenderThatProposalVotingIsClosed);
    event OpenDevelopment(uint256 _tenderThatDevelopmentIsOpen);
    event CloseDevelopment(uint256 _tenderThatDevelopmentIsClosed);
    event UpdateAdmin(uint256 _tenderAdminIsUpdated, address _oldAdmin, address _newAdmin);
    event UpdateSuperAdmin(address _oldSuperAdmin, address _newSuperAdmin);

    constructor() {
        owner = msg.sender;
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         CREATE FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function createTender(Tender memory _tender) public {

        _tender._tenderState = TenderState.VOTING;
        _tender.tenderID = s.numberOfTenders;
        _tender.numberOfVotes = 0;
        _tender.dateCreated = block.timestamp;

        s.tenders[s.numberOfTenders] = _tender;

        s.numberOfTenders++;

        emit TenderCreated(s.tenders[s.numberOfTenders - 1]);

    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         VIEW FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------


    function viewAllTenders() public view returns (Tender[] memory) {
        
        Tender[] memory tempTender = new Tender[](s.numberOfTenders);

        for (uint256 i = 0; i < s.numberOfTenders; i++) {
            tempTender[i] = s.tenders[i];
        }

        return tempTender;
    }

    function getTender(uint256 _tenderID) public view returns (Tender memory){
        return s.tenders[_tenderID];
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         GENERAL FUNCTIONALITY        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function voteForTender(uint256 _tenderID, uint256 _citizenID) public onlyCitizen(_citizenID) {
        require(
            s.tenders[_tenderID]._tenderState == TenderState.VOTING,
            "TENDER NOT IN VOTING STAGE"
        );

        require(s.citizens[_citizenID].totalPriorityPoints < s.tenders[_tenderID].priorityPoints, "NOT ENOUGH PRIORITY POINTS");

        uint256 tenderPriorityPoints = s.tenders[_tenderID].priorityPoints;
        
        s.citizens[_citizenID].totalPriorityPoints -= tenderPriorityPoints;
        s.tenders[_tenderID].numberOfVotes++;

        emit VoteSubmitted(msg.sender, _tenderID, s.tenders[_tenderID].numberOfVotes);
        
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         ONLY-ADMIN FUNCTIONALITY        ------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    /** 
        Calculating whether a project should progress to next voting stage based on how many votes it recieved
     */
    function closeVoting(uint256 _tenderID) public onlyAdmin(_tenderID) {

        uint256 totalTenderVotes = s.tenders[_tenderID].numberOfVotes;
        uint256 tenderThreshold = s.tenders[_tenderID].threshold;

        if (totalTenderVotes > (s.numberOfCitizens * tenderThreshold / 10000)) {
            s.tenders[_tenderID]._tenderState = TenderState.APPROVED;
        } else {
            s.tenders[_tenderID]._tenderState = TenderState.DECLINED;
        }

        emit VoteClosed(_tenderID);

    }

    function setThreshold(uint256 _threshold, uint256 _tenderID) public onlyAdmin(_tenderID) {

        uint256 oldThreshold = s.tenders[_tenderID].threshold;
        s.tenders[_tenderID].threshold = _threshold;

        emit UpdatedThreshold(oldThreshold, s.tenders[_tenderID].threshold);

    }

    function closeTender(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT || block.timestamp >= s.tenders[_tenderID].closingDate, "NOT ALLOWED TO CLOSE TENDER");

        s.tenders[_tenderID]._tenderState == TenderState.CLOSED;    

        emit TenderClosed(_tenderID);

    }

    function openProposals(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.APPROVED, "TENDER NOT APPROVED");
        
        s.tenders[_tenderID]._tenderState == TenderState.PROPOSING;    

        emit ProposalOpened(_tenderID);

    }

    function closeProposals(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.PROPOSING, "NOT IN PROPOSING STATE");

        s.tenders[_tenderID]._tenderState == TenderState.PROPOSAL_VOTING;   

        emit ProposalClosed(_tenderID); 
    }

    function closeProposalVoting(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.PROPOSAL_VOTING, "NOT CURRENT VOTING");

        proposalFacet.calculateWinningProposals(_tenderID);

        s.tenders[_tenderID]._tenderState == TenderState.AWARDED; 

        emit ProposalVotingClosed(_tenderID);  
    }

    function openProjectDevelopment(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.AWARDED, "NOT AWARDED");

        s.tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT;

        emit OpenDevelopment(_tenderID);

    }

    function closeProjectDevelopment(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT, "NOT IN DEVELOPMENT");

        s.tenders[_tenderID]._tenderState == TenderState.CLOSED;

        emit CloseDevelopment(_tenderID);

    }

    
}
