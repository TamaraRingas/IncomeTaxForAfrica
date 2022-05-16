// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../libraries/AppStorage.sol";

interface ITaxPayerCompanyFacet {

    function createCompany(TaxPayerCompany memory _company) external;

    function viewAllCompanies() external view returns (TaxPayerCompany[] memory);

    function getCompany(uint256 _companyID) external view returns (TaxPayerCompany memory);

    function updateEmployeeTax(uint256 _citizenID, uint256 _newSalary) external;

    function updateEmployeeSalary(uint256 _citizenID, uint256 _newSalary, uint256 _companyID) external;

    
}