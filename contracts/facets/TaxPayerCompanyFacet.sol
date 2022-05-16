// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/ITaxPayerCompanyFacet.sol";
import "../libraries/AppStorage.sol";

contract TaxPayerCompanyFacet {

    //TODO events
    //TODO view functions

    AppStorage internal s;

    IERC20 public USDC;

    address public treasuryAddress;


    event CompanyCreated(uint256 companyID);

    constructor(address _USDC, address _treasury) {
        s.USDAddress = _USDC;
        USDC = IERC20(_USDC);
        treasuryAddress = _treasury;
    }


    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         CREATE FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function createCompany(TaxPayerCompany _company) public {

        _company.companyID = s.numberOfCompanies;
        s.companies[s.numberOfCompanies] = _company;
        s.numberOfCompanies++;

        emit companyCreated(_company.companyID);
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         VIEW FUNCTIONS        --------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function viewAllCompanies() public view returns (TaxPayerCompany[] memory) {   
        
        TaxPayerCompany[] memory tempCompany = new TaxPayerCompany[](s.numberOfCompanies);

        for (uint256 i = 0; i < s.numberOfCompanies; i++) {
            tempCompany[i] = s.companies[i];
        }

        return tempCompany;
    }

    function getCompany(uint256 _companyID) public view returns (TaxPayerCompany memory){
        return s.companies[_companyID];
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         ONLY-ADMIN FUNCTIONALITY        ------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function payEmployeeTax(uint256 _companyID, uint256 _citizenID) public onlyAdmin(_companyID) {

        require(_companyID <= s.numberOfCompanies, "NOT A VALID COMPANY ID");
        require(_citizenID <= s.numberOfCitizens, "NOT A VALID CITIZEN ID");

        uint256 employeeTaxPercentage = s.citizens[_citizenID].taxPercentage;
        uint256 employeeSalary = s.employeeSalaries[_companyID][_citizenID];
        uint256 employeeTax = employeeTaxPercentage * employeeSalary / SCALE;
        uint256 priorityPoints = employeeSalary / 1000;

        require(USDC.balanceOf(treasuryAddress) > employeeTax, "NOT ENOUGH FUNDS");

        s.citizens[_citizenID].totalTaxPaid += employeeTax;
        s.citizens[_citizenID].totalPriorityPoints += priorityPoints;

        //TODO could someone call this and increase their points without the transfer?

        require(USDC.transfer(treasuryAddress, employeeTax), "TRANSFER FAILED");

    }

    function updateEmployeeSalary(uint256 _citizenID, uint256 _newSalary) public onlyAdmin (_companyID){
        require(_newSalary > 0, "SALARY TOO SMALL");
        require(_citizenID <= s.numberOfCitizens, "NOT A VALID CITIZEN ID");

        updateEmployeeTax(_citizenID, newTaxPercentage);

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

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         MODIFIERS       ----------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    modifier onlyAdmin(uint256 _companyID) {
        require(msg.sender = s.companies[_companyID].admin, "ONLY COMPANY ADMIN");
        _;
    }


    
}