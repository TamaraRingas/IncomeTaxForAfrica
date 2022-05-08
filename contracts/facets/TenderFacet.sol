// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ITenderFacet.sol";
import "../libraries/AppStorage.sol";

contract TenderFacet is ITenderFacet {

    mapping(uint256 => Tender) public tenders;

    uint256 public numberOfTenders;

    TenderState public _tenderState;
    Province public _province;

    constructor() {
        owner = msg.sender;
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         CREATE FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function createTender() external {

    

        numberOfTenders++;
    }

    function voteForTender(uint256 _tenderID) external onlyCitizen {
        require(
            projects[projectID]._projectState == ProjectState.VOTING,
            "PROJECT NOT IN VOTING STATE"
        );

        _voteForProject(_projectID);
    }

    function viewAllProjects() external view returns (Project[] memory) {
        Project[] memory tempProjects = new Project[](numberOfProjects);

        for (uint256 i = 0; i < numberOfProjects; i++) {
            tempProjects[i] = projects[i];
        }

        return tempProjects;
    }

    function viewSpecificSectorProjects(uint256 _sectorID)
        external
        view
        returns (Project[] memory)
    {
        Project[] memory tempProjects = new Project[](numberOfProjects);

        for (uint256 i = 0; i < numberOfProjects; i++) {
            if (projects[i].sectorID == _sectorID) {
                tempProjects[i] = projects[i];
            }
        }

        return tempProjects;
    }

    function getProject(uint256 _projectID)
        external
        view
        returns (Project memory)
    {
        return projects[_projectID];
    }

    function calculateProjectStatus(uint256 _projectID) public onlyOwner {
        _calculateProjectStatus(_projectID);
    }

    function closeProject(uint256 _projectID) public {
        require(projects[projectID]._projectState == ProjectState.DEVELOPMENT);
        _closeProject(_projectID);
    }

    function closeProjectsTendering(uint256 _projectID) public {
        require(projects[projectID]._projectState == ProjectState.TENDERING);
        _closeProjectsTendering(_projectID);
    }

    function openProjectDevelopment(uint256 _tenderID) public {
        _openProjectDevelopment(_tenderID);

    }
    function _voteForProject() internal {

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
        tenders[_tenderID]._tenderState == TenderState.CLOSED;    }

    function _closeProjectsTendering(uint256 _tenderID) internal {
        tenders[_tenderID]._tenderState == TenderState.TENDER_VOTING;    }
}
