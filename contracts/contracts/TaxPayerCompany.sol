// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/ITaxPayerCompany.sol";
import "../interfaces/ITreasury.sol";
import "./Proposal.sol";
import "./Citizen.sol";
import "./Sector.sol";
import "./Treasury.sol";

contract TaxPayerCompany is ITaxPayerCompany {

    //TODO events
    //TODO view functions

    address USDAddress;
    IERC20 USDC;

    uint256 public numberOfCompanies;

    Citizen public _citizen;
    Sector public _sector;

    event CompanyCreated(uint256 companyID);

    mapping(uint256 => TaxPayerCompany) companies;

    //Mapping of companyID => CitizenID => salary
    mapping(uint256 => mapping(uint256 => uint256)) employeeSalaries;

    constructor(address _USDC) {
        USDAddress = _USDC;
        USDC = IERC20(_USDC);
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         CREATE FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function createCompany(address _admin, address _wallet, string memory _name) public {


        TaxPayerCompany storage _company = s.companies[s.numberOfCompanies];

        _company.companyID = numberOfCompanies;
        _company.numberOfEmployees = 0;
        _company.admin = _admin;
        _company.wallet = _wallet;
        _company.name = _name;

        numberOfCompanies++;

        emit CompanyCreated(_company.companyID);
    }

    
    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         ONLY-ADMIN FUNCTIONALITY        ------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function payEmployeeTax(uint256 _companyID, uint256 _citizenID) public onlyCompanyAdmin(_companyID) {

        require(_companyID <= numberOfCompanies, "NOT A VALID COMPANY ID");
        require(_citizenID <= _citizen.numberOfCitizens, "NOT A VALID CITIZEN ID");

        uint256 employeeTaxPercentage = _citizen.citizens[_citizenID].taxPercentage;
        uint256 employeeGrossSalary = employeeSalaries[_companyID][_citizenID];
        uint256 employeeTax = employeeTaxPercentage * employeeGrossSalary / 10000;
        uint256 priorityPoints = employeeGrossSalary / 1000;
        uint256 employeeNetSalary = employeeGrossSalary - employeeTax;

        citizens[_citizenID].totalTaxPaid += employeeTax;
        citizens[_citizenID].totalPriorityPoints += priorityPoints;

        //TODO Approve transfer

        //Transferring of tax and salary to respective employee and treasury
        require(USDC.transfer(_citizen.citizens[_citizenID].walletAddress, employeeNetSalary), "TRANSFER FAILED");
        require(USDC.transfer(_treasury.TreasuryAddress, employeeTax), "TRANSFER FAILED");

        //Checks if the employees primary sector is full or there is still space for funds
        //Working on basis that the full tax has to be paid into the sector, not a portion only
        if(_sector.sectors[_citizen.citizens[_citizenID].primarySectorID].budgetReached == false){
            
            //Updates the sectors balance
            _sector.sectors[_citizen.citizens[_citizenID].primarySectorID].currentFunds += employeeTax;

            //Checks if the sector has enough funds and if so, updates the relevant boolean
            if(_sector.sectors[_citizen.citizens[_citizenID].primarySectorID].currentFunds >= _sector.sectors[_citizen.citizens[_citizenID].primarySectorID].budget) {
                _sector.sectors[_citizen.citizens[_citizenID].primarySectorID].budgetReached = true;
            }   
        } 
        else {
            //Checks if the employees secondary sector is full or there is still space for funds
            if(_sector.sectors[_citizen.citizens[_citizenID].secondarySectorID].budgetReached == false) {
                    
                //Updates sector balance
                _sector.sectors[_citizen.citizens[_citizenID].secondarySectorID].currentFunds += employeeTax;
            
                    //Checks if the sector has enough funds and if so, updates the relevant boolean
                    if(_sector.sectors[_citizen.citizens[_citizenID].secondarySectorID].currentFunds >= _sector.sectors[_citizen.citizens[_citizenID].secondarySectorID].budget) {
                            _sector.sectors[_citizen.citizens[_citizenID].secondarySectorID].budgetReached = true;
                    }
            }else {
                //Goes through to find a sector that has space for funds and updates its balance
                for(uint256 x = 0; x < _sector.numberOfSectors; x++){

                    if(_sector.sectors[x].currentFunds < (_sector.sectors[x].budget)){
                        _sector.sectors[x].currentFunds += employeeTax;
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

        employeeSalaries[_companyID][_citizenID] = _newSalary;
    }


    //----------------------------------------------------------------------------------------------------------------------
    //-------------------------------------        INTERNAL STATE-MODIFYING FUNCTIONS       --------------------------------
    //----------------------------------------------------------------------------------------------------------------------

     function updateEmployeeTax(uint256 _citizenID, uint256 _newSalary) internal {
        
        //Check tax tables and return correct tax percentage
        if(_newSalary >= 7000 && _newSalary < 20000){
            _citizen.citizens[_citizenID].taxPercentage = 1500;
        }else if(_newSalary >= 20000 && _newSalary < 30000) {
            _citizen.citizens[_citizenID].taxPercentage = 2200;
        }else if(_newSalary >= 30000 && _newSalary < 40000) {
            _citizen.citizens[_citizenID].taxPercentage = 2800;
        }else if(_newSalary >= 40000 && _newSalary < 50000) {
            _citizen.citizens[_citizenID].taxPercentage = 3300;
        }else if(_newSalary >= 50000 && _newSalary < 70000) {
            _citizen.citizens[_citizenID].taxPercentage = 3700;
        }else if(_newSalary >= 70000 && _newSalary < 100000) {
            _citizen.citizens[_citizenID].taxPercentage = 4000;
        }else if(_newSalary >= 100000 && _newSalary < 150000) {
            _citizen.citizens[_citizenID].taxPercentage = 4200;
        }else if(_newSalary >= 150000) {
            _citizen.citizens[_citizenID].taxPercentage = 4300;
        }
    }

    function addEmployee(uint256 _citizenID, uint256 _companyID) public {
        //Requires

        companies[_companyID].employees[_citizenID] = true;
        companies[_companyID].numberOfEmployees++;
    }

     modifier onlyCompanyAdmin(uint256 _companyID) {
        require(msg.sender == s.companies[_companyID].admin, "ONLY COMPANY ADMIN");
        _;
    }

}