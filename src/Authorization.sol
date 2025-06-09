//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 <0.9.0;

import {AccessControl} from "@openzeppelin-contracts/contracts/access/AccessControl.sol";
import {Constants} from "./const/Constants.sol";
import {DataTypes} from "./const/DataTypes.sol";
import {IAuthorization} from "./Interfaces/IAuthorization.sol";
import {Errors} from "./const/Errors.sol";

contract Authorization is IAuthorization, AccessControl, Constants, DataTypes, Errors {
    mapping(address => Asset) private s_allowedAssets;

    constructor(address _defaultAdmin) {
        _grantRole(DEFAULT_ADMIN_ROLE, _defaultAdmin);
    }

    modifier isTokenSupported(address _asset) {
        if (s_allowedAssets[_asset].asset == address(0)) {
            revert TokenIsNotSupported();
        }
        _;
    }

    function grantRole(bytes32 role, address account) public override onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(role, account);
    }
    /**
     * @dev details in IAuthorization
     */

    function addNewAsset(
        address _asset,
        address _priceFeed,
        uint256 _lendingRate,
        uint256 _borrowingRate,
        uint256 _collateralizationRatio,
        uint256 _heartBeat
    ) external onlyRole(ASSET_MANAGER_ROLE) {
        _addAsset(_asset, _priceFeed, _lendingRate, _borrowingRate, _collateralizationRatio, _heartBeat);
    }
    /**
     * @dev details in IAuthorization
     */

    function updateLendingRate(address _asset, uint256 _newRate)
        external
        onlyRole(ASSET_MANAGER_ROLE)
        isTokenSupported(_asset)
    {
        _updateLendingRate(_asset, _newRate);
    }
    /**
     * @dev details in IAuthorization
     */

    function updateBorrowingRate(address _asset, uint256 _newRate)
        external
        onlyRole(ASSET_MANAGER_ROLE)
        isTokenSupported(_asset)
    {
        _updateBorrowingRate(_asset, _newRate);
    }
    /**
     * @dev details in IAuthorization
     */

    function updateCollateralizationRatio(address _asset, uint256 _newRatio)
        external
        onlyRole(ASSET_MANAGER_ROLE)
        isTokenSupported(_asset)
    {
        _updateCollateralizationRatio(_asset, _newRatio);
    }

    /////////////////////////////////
    //// Internal/Private function ///
    /////////////////////////////////

    /**
     *
     * Internal function to validate address is not a zero address
     */
    function _validateAddress(address _address) internal pure {
        if (_address == address(0)) {
            revert InvalidAddress();
        }
    }
    /**
     *
     * Internal function to validate the rate been set make sure rate is not more than 10%
     */

    function _validateRate(uint256 _rate) internal pure {
        if (_rate == 0 || _rate > MAX_RATE) revert InvalidRate();
    }

    function _validateCollateralizationRatio(uint256 _ratio) internal pure {
        if (_ratio == 0 || _ratio < MINIMUM_COLLATERALIZATION_RATIO) revert InvalidRate();
    }

    /**
     *
     * Internal function to validate that heartbeat to set is up to the time required
     */
    function _validateHeartBeat(uint256 _heartBeat) internal pure {
        if (_heartBeat == 0 || _heartBeat > MAX_HEART_BEAT) revert InvalidHeartBeat();
    }

    function _addAsset(
        address _asset,
        address _priceFeed,
        uint256 _lendingRate,
        uint256 _borrowingRate,
        uint256 _collateralizationRatio,
        uint256 _heartBeat
    ) internal {
        _validateAddress(_asset);
        _validateAddress(_priceFeed);
        _validateRate(_lendingRate);
        _validateRate(_borrowingRate);
        _validateHeartBeat(_heartBeat);
        _validateCollateralizationRatio(_collateralizationRatio);
        Asset storage asset = s_allowedAssets[_asset];
        if (asset.asset != address(0)) revert TokenAlreadySupported();
        asset.asset = _asset;
        asset.borrowingRate = _borrowingRate;
        asset.lendingRate = _lendingRate;
        asset.collateralizationRatio = _collateralizationRatio;
        asset.heartBeat = _heartBeat;
        emit AssetAdded(_asset, _priceFeed, _lendingRate, _borrowingRate, _collateralizationRatio);
    }

    function _updateLendingRate(address _asset, uint256 _newRate) internal {
        _validateAddress(_asset);
        _validateRate(_newRate);
        Asset storage asset = s_allowedAssets[_asset];
        uint256 oldRate = asset.lendingRate;
        if (asset.lendingRate == _newRate) revert ValueNotChanged();
        asset.lendingRate = _newRate;
        emit LendingRateUpdated(_asset, oldRate, _newRate);
    }

    function _updateBorrowingRate(address _asset, uint256 _newRate) internal {
        _validateAddress(_asset);
        _validateRate(_newRate);
        Asset storage asset = s_allowedAssets[_asset];
        uint256 oldRate = asset.borrowingRate;
        if (asset.borrowingRate == _newRate) revert ValueNotChanged();
        asset.borrowingRate = _newRate;
        emit BorrowingRateUpdated(_asset, oldRate, _newRate);
    }

    function _updateCollateralizationRatio(address _asset, uint256 _newRatio) internal {
        _validateAddress(_asset);
        _validateCollateralizationRatio(_newRatio);
        Asset storage asset = s_allowedAssets[_asset];
        uint256 oldRatio = asset.collateralizationRatio;
        if (asset.collateralizationRatio == _newRatio) revert ValueNotChanged();
        asset.collateralizationRatio = _newRatio;
        emit CollateralizationRatioUpdated(_asset, oldRatio, _newRatio);
    }
}
