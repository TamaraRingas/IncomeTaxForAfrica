// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

struct User {
    string name;
    uint96 age; // uint96 = 8 bytes, to pack with 20 byte address below
    address walletAddress;
}

// All state shared across the protocol goes here
struct AppStorage {
    mapping(uint256 => User) users;
    uint256 userCount;
    User oldestUser;
}

library LibAppStorage {
    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }
}