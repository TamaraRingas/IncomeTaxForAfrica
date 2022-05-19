// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

interface ICitizen {

    function selectSectors(uint256 _citizenID, uint256 _primarySectorID, uint256 _secondarySectorID) external;

    function register(Citizen memory _citizen) external;
    
}