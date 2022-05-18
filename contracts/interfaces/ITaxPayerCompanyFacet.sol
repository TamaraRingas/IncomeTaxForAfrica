// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../libraries/AppStorage.sol";

interface ITaxPayerCompanyFacet {

    function payEmployeeTax(uint256 _companyID, uint256 _citizenID) external;

    function updateEmployeeSalary(uint256 _citizenID, uint256 _newSalary, uint256 _companyID) external;

    function addEmployee(uint256 _citizenID, uint256 _companyID) external;
}