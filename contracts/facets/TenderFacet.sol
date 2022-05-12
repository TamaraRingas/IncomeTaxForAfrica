// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ITenderFacet.sol";
import "../libraries/AppStorage.sol";
import "./CitizenFacet.sol";

contract TenderFacet is ITenderFacet {

    AppStorage internal s;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    //TODO implement priority points for voting
    //TODO events
    //TODO check we have enough requires

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         CREATE FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    //How to send in Tender object
    function createTender(Tender _tender) public {

        _tender._tenderState = TenderState.VOTING;
        _tender.tenderID = s.numberOfTenders;
        _tender.numberOfVotes = 0;
        _tender.dateCreated = block.timestamp;

        s.tenders[s.numberOfTenders] = _tender;

        s.numberOfTenders++;

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

    function viewSpecificSectorTenders(uint256 _sectorID)
        public
        view
        returns (Tender[] memory)
    {
        Tender[] memory tempTender = new Tender[](s.numberOfTenders);

        for (uint256 i = 0; i < s.numberOfTenders; i++) {
            if (s.tenders[i].sectorID == _sectorID) {
                tempTender[i] = s.tenders[i];
            }
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

        require(s.citizens[_citizenID].totalPriorityPoints < s.tenders[_tenderID].priorityPoints, "NOT ENOUGH PRIORITY POIINTS");

        uint256 tenderPriorityPoints = s.tenders[_tenderID].priorityPoints;
        s.citizens[_citizenID].totalPriorityPoints -= tenderPriorityPoints;

        s.tenders[_tenderID].numberOfVotes++;
        
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

        if (totalTenderVotes > (CitizenFacet.numberOfCitizens() * tenderThreshold / 10000)) {
            s.tenders[_tenderID]._tenderState = TenderState.APPROVED;
        } else {
            s.tenders[_tenderID]._tenderState = TenderState.DECLINED;
        }

    }

    function setThreshold(uint256 _threshold, uint256 _tenderID) public onlyAdmin(_tenderID) {
        s.tenders[_tenderID].threshold = _threshold;

    }

    function closeTender(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT || block.timestamp >= s.tenders[_tenderID].closingDate, "NOT ALLOWED TO CLOSE TENDER");

        s.tenders[_tenderID]._tenderState == TenderState.CLOSED;    

    }

    function openProposals(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.APPROVED, "TENDER NOT APPROVED");
        
        s.tenders[_tenderID]._tenderState == TenderState.PROPOSING;    

    }

    function closeProposals(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.PROPOSING, "NOT IN PROPOSING STATE");

        s.tenders[_tenderID]._tenderState == TenderState.PROPOSAL_VOTING;    
    }

    function closeProposalVoting(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.PROPOSAL_VOTING, "NOT CURRENT VOTING");

        //Set the winning proposals enum to successfull

        s.tenders[_tenderID]._tenderState == TenderState.AWARDED;    
    }

    function openProjectDevelopment(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.AWARDED, "NOT AWARDED");

        s.tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT;

    }

    function closeProjectDevelopment(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(s.tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT, "NOT IN DEVELOPMENT");

        s.tenders[_tenderID]._tenderState == TenderState.CLOSED;

    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         ONLY-OWNER FUNCTIONALITY        ------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function setAdmin(uint256 _tenderID, address _admin) public onlyOwner(){
        require(_admin != address(0), "CANNOT BE ZERO ADDRESS");

        s.tenders[_tenderID].admin = _admin;
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         MODIFIERS       ----------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------


    modifier onlyAdmin(uint256 _tenderID) {
        require(msg.sender == s.tenders[_tenderID].admin, "ONLY ADMIN");
        _;
    }

    modifier onlyCitizen(uint256 _citizenID) {
        require(_citizenID < CitizenFacet.numberOfCitizens(), "ONLY CITIZENS");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "ONLY OWNER");
        _;
    }
}
