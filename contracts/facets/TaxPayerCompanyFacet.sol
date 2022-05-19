// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/ITaxPayerCompanyFacet.sol";
import { AppStorage } from "../libraries/AppStorage.sol";

contract TaxPayerCompanyFacet is ITaxPayerCompanyFacet{

    //TODO events
    //TODO view functions

    struct TaxPayerCompany {
    uint256 companyID;
    uint256 numberOfEmployees;
    address admin;
    address wallet;
    string name;
    mapping(uint256 => bool) employees;
    mapping(uint256 => Proposal) currentProposals;
    }

    event CompanyCreated(uint256 companyID);

    mapping(uint256 => TaxPayerCompany) companies;

    //Mapping of companyID => CitizenID => salary
    mapping(uint256 => mapping(uint256 => uint256)) employeeSalaries;

    constructor(address _USDC, address _treasury) {
        s.USDAddress = _USDC;
        s.USDC = IERC20(_USDC);
        s.TreasuryAddress = _treasury;
    }


    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         CREATE FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function createCompany(address _admin, address _wallet, string memory _name) public {


        TaxPayerCompany storage _company = s.companies[s.numberOfCompanies];

        _company.companyID = s.numberOfCompanies;
        _company.numberOfEmployees = 0;
        _company.admin = _admin;
        _company.wallet = _wallet;
        _company.name = _name;

        s.numberOfCompanies++;

        emit CompanyCreated(_company.companyID);
    }

    
    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         ONLY-ADMIN FUNCTIONALITY        ------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function payEmployeeTax(uint256 _companyID, uint256 _citizenID) public onlyCompanyAdmin(_companyID) {

        require(_companyID <= s.numberOfCompanies, "NOT A VALID COMPANY ID");
        require(_citizenID <= s.numberOfCitizens, "NOT A VALID CITIZEN ID");

        uint256 employeeTaxPercentage = s.citizens[_citizenID].taxPercentage;
        uint256 employeeGrossSalary = s.employeeSalaries[_companyID][_citizenID];
        uint256 employeeTax = employeeTaxPercentage * employeeGrossSalary / 10000;
        uint256 priorityPoints = employeeGrossSalary / 1000;
        uint256 employeeNetSalary = employeeGrossSalary - employeeTax;

        s.citizens[_citizenID].totalTaxPaid += employeeTax;
        s.citizens[_citizenID].totalPriorityPoints += priorityPoints;

        //TODO Approve transfer

        //Transferring of tax and salary to respective employee and treasury
        require(s.USDC.transfer(s.citizens[_citizenID].walletAddress, employeeNetSalary), "TRANSFER FAILED");
        require(s.USDC.transfer(s.TreasuryAddress, employeeTax), "TRANSFER FAILED");

        //Checks if the employees primary sector is full or there is still space for funds
        //Working on basis that the full tax has to be paid into the sector, not a portion only
        if(s.sectors[s.citizens[_citizenID].primarySectorID].budgetReached == false){
            
            //Updates the sectors balance
            s.sectors[s.citizens[_citizenID].primarySectorID].currentFunds += employeeTax;

            //Checks if the sector has enough funds and if so, updates the relevant boolean
            if(s.sectors[s.citizens[_citizenID].primarySectorID].currentFunds >= s.sectors[s.citizens[_citizenID].primarySectorID].budget) {
                s.sectors[s.citizens[_citizenID].primarySectorID].budgetReached = true;
            }   
        } 
        else {
            //Checks if the employees secondary sector is full or there is still space for funds
            if(s.sectors[s.citizens[_citizenID].secondarySectorID].budgetReached == false) {
                    
                //Updates sector balance
                s.sectors[s.citizens[_citizenID].secondarySectorID].currentFunds += employeeTax;
            
                    //Checks if the sector has enough funds and if so, updates the relevant boolean
                    if(s.sectors[s.citizens[_citizenID].secondarySectorID].currentFunds >= s.sectors[s.citizens[_citizenID].secondarySectorID].budget) {
                            s.sectors[s.citizens[_citizenID].secondarySectorID].budgetReached = true;
                    }
            }else {
                //Goes through to find a sector that has space for funds and updates its balance
                for(uint256 x = 0; x < s.numberOfSectors; x++){

                    if(s.sectors[x].currentFunds < (s.sectors[x].budget)){
                        s.sectors[x].currentFunds += employeeTax;
                        break;
                    }
                }
            }
        }
    }

    function updateEmployeeSalary(uint256 _citizenID, uint256 _newSalary, uint256 _companyID) public onlyCompanyAdmin (_companyID){
        require(_newSalary > 0, "SALARY TOO SMALL");

        //Need to check if is an employee

        updateEmployeeTax(_citizenID, _newSalary);

        s.employeeSalaries[_companyID][_citizenID] = _newSalary;
    }


    //----------------------------------------------------------------------------------------------------------------------
    //-------------------------------------        INTERNAL STATE-MODIFYING FUNCTIONS       --------------------------------
    //----------------------------------------------------------------------------------------------------------------------

     function updateEmployeeTax(uint256 _citizenID, uint256 _newSalary) internal {
        
        //Check tax tables and return correct tax percentage
        if(_newSalary >= 7000 && _newSalary < 20000){
            s.citizens[_citizenID].taxPercentage = 1500;
        }else if(_newSalary >= 20000 && _newSalary < 30000) {
            s.citizens[_citizenID].taxPercentage = 2200;
        }else if(_newSalary >= 30000 && _newSalary < 40000) {
            s.citizens[_citizenID].taxPercentage = 2800;
        }else if(_newSalary >= 40000 && _newSalary < 50000) {
            s.citizens[_citizenID].taxPercentage = 3300;
        }else if(_newSalary >= 50000 && _newSalary < 70000) {
            s.citizens[_citizenID].taxPercentage = 3700;
        }else if(_newSalary >= 70000 && _newSalary < 100000) {
            s.citizens[_citizenID].taxPercentage = 4000;
        }else if(_newSalary >= 100000 && _newSalary < 150000) {
            s.citizens[_citizenID].taxPercentage = 4200;
        }else if(_newSalary >= 150000) {
            s.citizens[_citizenID].taxPercentage = 4300;
        }
    }

    function addEmployee(uint256 _citizenID, uint256 _companyID) public {
        //Requires

        s.companies[_companyID].employees[_citizenID] = true;
        s.companies[_companyID].numberOfEmployees++;
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