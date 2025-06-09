//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 <0.9.0;

contract DataTypes {
    struct Asset {
        address asset;
        address priceFeed;
        uint256 lendingRate;
        uint256 borrowingRate;
        uint256 collateralizationRatio;
        uint256 totalBorrowed;
        uint256 totalDeposited;
        uint256 heartBeat;
    }
}
