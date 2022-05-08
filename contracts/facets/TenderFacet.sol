// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {ITenderFacet} from "../interfaces/ITenderFacet.sol";
import {AppStorage} from "../libraries/AppStorage.sol";

contract TenderFacet is ITenderFacet {

    mapping(uint256 => Tender) public tenders;

    uint256 numberOfTenders;

    TenderState public _tenderState;
    Province public _province;

    constructor() {
        owner = msg.sender;
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         CREATE FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function createTender(Tender memory _tender) external {

        _tender._tenderState = TenderState.VOTING;
        _tender.tenderID = numberOfTenders;
        _tender.numberOfVotes = 0;
        _tender.dateCreated = block.timestamp;

        tenders[numberOfTenders] = _tender;

        numberOfTenders++;

    }

    function voteForTender(uint256 _tenderID) external onlyCitizen {
        require(
            projects[projectID]._projectState == ProjectState.VOTING,
            "PROJECT NOT IN VOTING STATE"
        );


        
    }

    function viewAllTenders() external view returns (Tender[] memory) {
        
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
        Tender[] memory tempTender = new Project[](numberOfTenders);

        for (uint256 i = 0; i < numberOfTenders; i++) {
            if (tenders[i].sectorID == _sectorID) {
                tempTenders[i] = tenders[i];
            }
        }

        return tempTender;
    }

    function getTender(uint256 _tenderID)
        external
        view
        returns (Tender memory)
    {
        return tenders[_tenderID];
    }

    /** 
        Calculating whether a project should progress to next voting stage based on how many votes it recieved

        TODO - fugure out calculation or method to determine if the project should move forward
    
     */
    function calculateProjectStatus(uint256 _tenderID) public onlyOwner {

        uint256 totalProjectVotes = projects[_projectID].numberOfVotes;

        if (totalProjectVotes > 10) {
            projects[_projectID]._projectState = ProjectState.APPROVED;
        } else {
            projects[_projectID]._projectState = ProjectState.DECLINED;
        }

    }

    function setThreshold(uint256 _threshold, uint256 _tenderID) public onlyAdmin(_tenderID) {
        tenders[_tenderID].threshold = _threshold;

    }

    function closeTender(uint256 _tenderID) public {
        require(tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT || block.timestamp >= tenders[_tenderID].closingDate, "");

        tenders[_tenderID]._tenderState == TenderState.CLOSED;    


    }

    function closeProjectsTendering(uint256 _projectID) public {
        require(projects[projectID]._projectState == ProjectState.TENDERING);

        _closeProjectsTendering(_projectID);
    }

    function openProjectDevelopment(uint256 _tenderID) public {
        _openProjectDevelopment(_tenderID);

    }
    
    /**
        Calculating whether a project should progress to next voting stage based on how many votes it recieved

        TODO - fugure out calculation or method to determine if the project should move forward
    
     */
    function _calculateProjectStatus(uint256 _projectID) internal {
        uint256 totalProjectVotes = projects[_projectID].numberOfVotes;

        if (totalProjectVotes > 10) {
            projects[_projectID]._projectState = ProjectState.APPROVED;
        } else {
            projects[_projectID]._projectState = ProjectState.DECLINED;
        }
    }

    function _openProjectDevelopment(uint256 _tenderID) internal {
        tenders[_tenderID]._tenderState == TenderState.DEVELOPMENT;
    }

    function _closeProject(uint256 _tenderID) internal {
        tenders[_tenderID]._tenderState == TenderState.CLOSED;    
    }

    function _closeProjectsTendering(uint256 _tenderID) internal {
        tenders[_tenderID]._tenderState == TenderState.TENDER_VOTING;    
    }

    modifier onlyAdmin(uint256 _tenderID) {
        require(msg.sender == tenders[_tenderID].admin)
        _;
    }
}
