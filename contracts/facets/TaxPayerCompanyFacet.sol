// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ITaxPayerCompanyFacet.sol";
import "../libraries/AppStorage.sol";

contract TaxPayerCompanyFacet {

    //TODO events
    //TODO view functions

    AppStorage internal s;

    uint256 private SCALE = 10000;

    IERC20 public USDC;

    address public USDCAddress;
    address public treasuryAddress;


    event CompanyCreated(uint256 companyID);

    constructor(address _USDC, address _treasury) {
        usdcAddress = _USDC;
        USDC = IERC(_USDC);
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

        require(USDC.balanceOf(treasuryAddress) > employeeTax, "NOT ENOUGH FUNDS");

        //Increase tax paid of citizen
        s.citizens[_citizenID].totalTaxPaid += employeeTax;
        
        uint256 priorityPoints = employeeSalary / 1000;
        
        //Increase priority points
        s.citizens[_citizenID].totalPriorityPoints += priorityPoints;

        //TODO could someone call this and increase their points without the transfer?

        //Pay the employeeTax to treasury
        require(USDC.transfer(_treasury, employeeTax), "TRANSFER FAILED");

    }

    function updateEmployeeSalary(uint256 _citizenID, uint256 _newSalary) public onlyAdmin (_companyID){
        require(_newSalary > 0, "SALARY TOO SMALL");
        require(_citizenID <= s.numberOfCitizens, "NOT A VALID CITIZEN ID");


        uint256 newTaxPercentage = calculateTax(_newSalary);

        updateEmployeeTax(_citizenID, newTaxPercentage);

        s.employeeSalaries[_companyID][_citizenID] = _newSalary;
    }


    function changeAdmin(uint256 _companyID, address _newAdmin) public onlyAdmin (_companyID) {
        require(_newAdmin != address(0), "CANNOT BE ZERO ADDRESS");
        require(_companyID <= s.numberOfCompanies, "NOT A VALID COMPANY ID");

        s.companies[_companyID].admin = _newAdmin;
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-------------------------------------        INTERNAL STATE-MODIFYING FUNCTIONS       --------------------------------
    //----------------------------------------------------------------------------------------------------------------------


    function calculateTax(uint256 _newSalary) internal returns (uint256) {
        //Check tax tables and return correct tax percentage
    }

     function updateEmployeeTax(uint256 _citizenID, uint256 _newTaxPercentage) internal {
        s.citizens[_citizenID].taxPercentage = _newTaxPercentage;
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         MODIFIERS       ----------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    modifier onlyAdmin(uint256 _companyID) {
        require(msg.sender = s.companies[_companyID].admin, "ONLY COMPANY ADMIN");
        _;
    }


    
}