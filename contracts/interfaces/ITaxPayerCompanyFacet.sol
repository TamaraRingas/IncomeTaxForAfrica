// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../libraries/AppStorage.sol";

interface ITaxPayerCompanyFacet {

    function createCompany(TaxPayerCompany _company) external;

     function viewAllCompanies() external view returns (TaxPayerCompany[] memory);

     function getCompany(uint256 _companyID) external view returns (TaxPayerCompany memory);

     function payEmployeeTax(uint256 _companyID, uint256 _citizenID) external;

     function updateEmployeeSalary(uint256 _citizenID, uint256 _newSalary) external;

     function changeAdmin(uint256 _companyID, address _newAdmin) external;


    
}