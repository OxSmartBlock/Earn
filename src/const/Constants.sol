//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 <0.9.0;

contract Constants {
    bytes32 ASSET_MANAGER_ROLE = keccak256("ASSET_MANAGER");
    uint256 constant DIVISOR = 10_000;
    uint256 constant MAX_RATE = 1_000;
    uint256 constant MAX_HEART_BEAT = 2 hours;
    uint256 constant MINIMUM_COLLATERALIZATION_RATIO = 5_000;
}
