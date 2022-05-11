// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ITaxPayerCompanyFacet.sol";
import "../libraries/AppStorage.sol";

contract TaxPayerCompanyFacet {

    //TODO events
    //TODO view functions
    //TODO requires

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

    function payEmployeeTax(uint256 _companyID, uint256 _citizenID) public onlyAdmin(_companyID) {

        uint256 employeeTaxPercentage = s.citizens[_citizenID].taxPercentage;
        uint256 employeeSalary = s.employeeSalaries[_companyID][_citizenID];

        uint256 employeeTax = employeeTaxPercentage * employeeSalary / SCALE;

        require(USDC.balanceOf(treasuryAddress) > employeeTax, "NOT ENOUGH FUNDS");

        //Increase tax paid of citizen
        s.citizens[_citizenID].totalTaxPaid += employeeTax;
        
        uint256 priorityPoints = employeeTax / 1000;
        
        //Increase priority points
        s.citizens[_citizenID].totalPriorityPoints += priorityPoints;

        //TODO could someone call this and increase their points without the transfer?

        //Pay the employeeTax to treasury
        require(USDC.transfer(_treasury, employeeTax), "TRANSFER FAILED");

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


    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         ONLY-ADMIN FUNCTIONALITY        ------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    function updateEmployeeSalary(uint256 _citizenID, uint256 _newSalary) public onlyAdmin (_companyID){
        s.employeeSalaries[_companyID][_citizenID] = _newSalary;
    }

    function updateEmployeeTax(uint256 _citizenID, uint256 _newTaxPercentage) public onlyAdmin (_companyID){
        s.citizens[_citizenID].taxPercentage = _newTaxPercentage;
    }

    function changeAdmin(uint256 _companyID, address _newAdmin) public onlyAdmin (_companyID) {
        s.companies[_companyID].admin = _newAdmin;
    }

    //----------------------------------------------------------------------------------------------------------------------
    //-----------------------------------------         MODIFIERS       ----------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------

    modifier onlyAdmin(uint256 _companyID) {
        require(msg.sender = s.companies[_companyID].companyID, "ONLY COMPANY ADMIN");
        _;
    }


    
}