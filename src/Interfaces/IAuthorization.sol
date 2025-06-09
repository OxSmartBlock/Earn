//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 <0.9.0;

interface IAuthorization {
    event AssetAdded(
        address indexed _asset,
        address indexed _priceFeed,
        uint256 _lendingRate,
        uint256 _borrowingRate,
        uint256 _collateralizationRatio
    );
    event LendingRateUpdated(address indexed _asset, uint256 _oldRate, uint256 _newRate);
    event BorrowingRateUpdated(address indexed _asset, uint256 _oldRate, uint256 _newRate);
    event CollateralizationRatioUpdated(address indexed _asset, uint256 _oldRatio, uint256 _newRatio);
    /**
     *
     * @param _asset contract address of asset to be added as supported asset
     * @param _priceFeed oracle price feed address of the asset Asset/USD
     * @param _lendingRate rate which user would earn for their asset deposit
     * @param _borrowingRate the rate which loan taker would pay for their loans
     * @param _collateralizationRatio asset collateralization ratio
     */

    function addNewAsset(
        address _asset,
        address _priceFeed,
        uint256 _lendingRate,
        uint256 _borrowingRate,
        uint256 _collateralizationRatio,
        uint256 _heartBeat
    ) external;

    /**
     *
     * @param _asset asset which lending rate is been updated
     * @param _newRate the new lending rate
     */
    function updateLendingRate(address _asset, uint256 _newRate) external;
    /**
     *
     * @param _asset asset which borrowing rate is been updated
     * @param _newRate the new borrowing rate
     */
    function updateBorrowingRate(address _asset, uint256 _newRate) external;
    /**
     *
     * @param _asset asset which collateralization ratio is been updated
     * @param _newRatio the new collaterlization ratio
     */
    function updateCollateralizationRatio(address _asset, uint256 _newRatio) external;
}
