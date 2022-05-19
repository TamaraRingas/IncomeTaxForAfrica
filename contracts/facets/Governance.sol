// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "..//interfaces/IGovernance.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Governance is IGovernance, Ownable, ReentrancyGuard {

  address superAdmin;

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  EVENTS        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  event SetSuperAdmin(address previousSuperAdmin, address newAdmin, uint256 time);
  event SetTenderAdmin(uint256 tenderID,address previousAdmin, address newAdmin, uint256 time);
  event SetSectorAdmin(uint256 sectorID, address newAdmin, uint256 time);
  event ChangeCompanyAdmin(uint256 companyID,address previousAdmin, address newAdmin, uint256 time);
  event SetSupervisor(uint256 proposalID, address previousSupervisor, address newSupervisor, uint256 time);

  event TreasuryBalanceUpdated(uint256 increasedBy);
  event SectorBudgetUpdated(uint256 newBudget);

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  CONSTRUCTOR        ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  constructor (address _USDC) {
    s.USDAddress = _USDC;
    s.USDC = IERC20(_USDC);
    s.superAdmin = msg.sender;
  }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  ACCESS FUNCTIONS       ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function setSuperAdmin(address _newSuperAdmin) public onlySuperAdmin(){
        require(_newSuperAdmin != address(0), "CANNOT BE ZERO ADDRESS");

        address previousSuperAdmin = s.superAdmin;

        s.superAdmin = _newSuperAdmin;

        emit SetSuperAdmin(previousSuperAdmin, s.superAdmin, block.timestamp);
  }

  function setTenderAdmin(uint256 _tenderID, address _admin) public onlySuperAdmin(){
        require(_admin != address(0), "CANNOT BE ZERO ADDRESS");

        address previousAdmin =  s.tenders[_tenderID].admin;

        s.tenders[_tenderID].admin = _admin;

        emit SetTenderAdmin(_tenderID, previousAdmin, s.tenders[_tenderID].admin, block.timestamp);
  }


  function setSectorAdmin(uint256 _sectorID, address _newAdmin) public onlyOwner {
    require(_newAdmin != address(0), "CANNOT BE ZERO ADDRESS");

    s.sectors[_sectorID].sectorAdmins[_newAdmin] = true; 

    emit SetSectorAdmin(_sectorID, _newAdmin, block.timestamp);
  }

  function changeCompanyAdmin(uint256 _companyID, address _newAdmin) public onlyAdmin (_companyID) {
        require(_newAdmin != address(0), "CANNOT BE ZERO ADDRESS");
        require(_companyID <= s.numberOfCompanies, "NOT A VALID COMPANY ID");

        address previousAdmin =  s.companies[_companyID].admin;
        s.companies[_companyID].admin = _newAdmin;

        emit ChangeCompanyAdmin(_companyID, previousAdmin, s.companies[_companyID].admin, block.timestamp);
  }
  
  function setSupervisor(uint256 _proposalID, address _newSupervisor) public onlySupervisor(_proposalID) {
    require(_newSupervisor != address(0), "CANNOT BE ZERO ADDRESS");
    require(_proposalID <= s.numberOfProposals, "NOT A VALID COMPANY ID");

    address previousSupervisor =  s.proposals[_proposalID].supervisor;

    s.proposals[_proposalID].supervisor = _newSupervisor;

    emit SetSupervisor(_proposalID, previousSupervisor, _newSupervisor, block.timestamp);
  } 

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------  GENERAL FUNCTIONS       ---------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

  function fundTreasury(uint256 _amount) public onlySuperAdmin() nonReentrant {

    s.USDC.transfer(s.TreasuryAddress, _amount);

    emit TreasuryBalanceUpdated(_amount);
  }

  function updateBudget(uint256 _sectorID, uint256 _newBudget) public onlySuperAdmin() {
    s.sectors[_sectorID].budget = _newBudget;

    emit SectorBudgetUpdated(_newBudget);
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