// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {ITenderFacet} from "../interfaces/ITenderFacet.sol";
import {AppStorage} from "../libraries/AppStorage.sol";
import {CitizenFacet} from "./CitizenFacet.sol";

contract TenderFacet is ITenderFacet {

    
    enum TenderState {
        VOTING,
        APPROVED,
        DECLINED,
        PROPOSING,
        PROPOSAL_VOTING,
        AWARDED,
        DEVELOPMENT,
        CLOSED
    }

    mapping(uint256 => Tender) public tenders;

    uint256 public constant SCALE = 10_000; //Scale of 10000

    uint256 public numberOfTenders;

    TenderState public _tenderState;
    Province public _province;

    constructor() {
        owner = msg.sender;
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         CREATE FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function createTender(Tender memory _tender) public {

        _tender._tenderState = TenderState.VOTING;
        _tender.tenderID = numberOfTenders;
        _tender.numberOfVotes = 0;
        _tender.dateCreated = block.timestamp;

        tenders[numberOfTenders] = _tender;

        numberOfTenders++;

    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         VIEW FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------


    function viewAllTenders() public view returns (Tender[] memory) {
        
        Tender[] memory tempTender = new Tender[](numberOfTenders);

        for (uint256 i = 0; i < numberOfTenders; i++) {
            tempTender[i] = tenders[i];
        }

        return tempTender;
    }

    function viewSpecificSectorTenders(uint256 _sectorID)
        external
        view
        returns (Tender[] memory)
    {
        Tender[] memory tempTender = new Tender[](numberOfTenders);

        for (uint256 i = 0; i < numberOfTenders; i++) {
            if (tenders[i].sectorID == _sectorID) {
                tempTenders[i] = tenders[i];
            }
        }

        return tempTender;
    }

    function getTender(uint256 _tenderID) external view returns (Tender memory){
        return tenders[_tenderID];
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         GENERAL FUNCTIONALITY        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function voteForTender(uint256 _tenderID, uint256 _citizenID) public onlyCitizen(_citizenID) {
        require(
            tenders[_tenderID]._tenderState == TenderState.VOTING,
            "TENDER NOT IN VOTING STAGE"
        );

        tenders[_tenderID].numberOfVotes++;
        
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         ONLY-ADMIN FUNCTIONALITY        ------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    /** 
        Calculating whether a project should progress to next voting stage based on how many votes it recieved
     */
    function closeVoting(uint256 _tenderID) public onlyAdmin(_tenderID) {

        uint256 totalTenderVotes = tenders[_tenderID].numberOfVotes;
        uint256 tenderThreshold = tenders[_tenderID].threshold;

        if (totalTenderVotes > (CitizenFacet.numberOfCitizens() * tenderThreshold / SCALE)) {
            tenders[_tenderID]._tenderState = TenderState.APPROVED;
        } else {
            tenders[_tenderID]._tenderState = TenderState.DECLINED;
        }

    }

    function setThreshold(uint256 _threshold, uint256 _tenderID) public onlyAdmin(_tenderID) {
        tenders[_tenderID].threshold = _threshold;

    }

    function closeTender(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT || block.timestamp >= tenders[_tenderID].closingDate, "NOT ALLOWED TO CLOSE TENDER");

        tenders[_tenderID]._tenderState == TenderState.CLOSED;    

    }

    function openProposals(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(tenders[_tenderID]._tenderState == TenderState.APPROVED, "TENDER NOT APPROVED");
        
        tenders[_tenderID]._tenderState == TenderState.PROPOSING;    

    }

    function closeProposals(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(tenders[_tenderID]._tenderState == TenderState.PROPOSING, "NOT IN PROPOSING STATE");

        tenders[_tenderID]._tenderState == TenderState.PROPOSAL_VOTING;    
    }

    function closeProposalVoting(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(tenders[_tenderID]._tenderState == TenderState.PROPOSAL_VOTING, "NOT CURRENT VOTING");

        //Set the winning proposals enum to successfull

        tenders[_tenderID]._tenderState == TenderState.AWARDED;    
    }

    function openProjectDevelopment(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(tenders[_tenderID]._tenderState == TenderState.AWARDED, "NOT AWARDED");

        tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT;

    }

    function closeProjectDevelopment(uint256 _tenderID) public onlyAdmin(_tenderID){

        require(tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT, "NOT IN DEVELOPMENT");

        tenders[_tenderID]._tenderState == TenderState.CLOSED;

    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         MODIFIERS       ----------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------


    modifier onlyAdmin(uint256 _tenderID) {
        require(msg.sender == tenders[_tenderID].admin, "ONLY ADMIN");
        _;
    }

    modifier onlyCitizen(uint256 _citizenID) {
        require(_citizenID < CitizenFacet.numberOfCitizens(), "ONLY CITIZENS");
        _;
    }
}
