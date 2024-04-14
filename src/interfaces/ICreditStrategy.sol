pragma solidity ^0.8.13;

import { ICreditOracle } from '@interfaces/ICreditOracle.sol';

interface ICreditStrategy {

    function query(
        ICreditOracle.Market entries, 
        uint256 timestamp, 
        uint256 count
    ) external returns (uint256,  uint256, uint256);

}