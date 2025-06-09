//SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 <0.9.0;
import {Authorization} from "./Authorization.sol";
import {IEarn} from "./Interfaces/IEarn.sol";

contract Earn is IEarn, Authorization{

    constructor(address _defaultAdmin) Authorization(_defaultAdmin){

    }

}
