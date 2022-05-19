// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./IProposal.sol";

interface ITaxPayerCompany {

    struct TaxPayerCompany {
    uint256 companyID;
    uint256 numberOfEmployees;
    address admin;
    address wallet;
    string name;
    mapping(uint256 => bool) employees;
    mapping(uint256 => IProposal.Proposal) currentProposals;
    uint256 numberOfProposals;
    }

    function payEmployeeTax(uint256 _companyID, uint256 _citizenID) external;

    function updateEmployeeSalary(uint256 _citizenID, uint256 _newSalary, uint256 _companyID) external;

    function addEmployee(uint256 _citizenID, uint256 _companyID) external;

    function getCompanyAdmin(uint256 _companyID) external view returns (address);

    function getCompanyWallet(uint256 _companyID) external view returns (address);

    function getAllProposals(uint256 _companyID) external view returns (IProposal.Proposal[] memory);
}