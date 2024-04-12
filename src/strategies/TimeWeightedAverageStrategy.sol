pragma solidity ^0.8.13;

import { ICreditOracle } from '@interfaces/ICreditOracle.sol';

contract TimeWeightedAverageStrategy {

    function query(
        ICreditOracle.market entries, 
        uint256 timestamp,
        uint256 count
    ) 
        public view 
        returns (uint256, uint256, uint256)
    {
        uint256 queryNum;
        uint256 queryDenom;
        uint256 subsequent = timestamp;

        for (uint256 x = 0; x < count; x++) {
            ICreditOracle.Entry storage entry = entries[subsequent];

            uint256 deltaTime = subsequent - entry.predecessor;

            queryNum += deltaTime * entry.rate;
            queryDenom += deltaTime;

            subsequent = entry.predecessor;
        }

        uint256 rateWeighted = queryNum / queryDenom;

        return (rateWeighted, queryDenom, subsequent);
    }

}