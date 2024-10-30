pragma solidity ^0.8.13;

import { ICreditOracle } from '@interfaces/ICreditOracle.sol';

contract RollingMovingAverageStrategy {
    function query(
        ICreditOracle.Market memory entries,
        uint256 timestamp,
        uint256 count
    ) 
        public view 
        returns (uint256, uint256, uint256) 
    {
        uint256 rollingSum;
        uint256 subsequent = timestamp;
        
        for (uint256 x = 0; x < count; x++) {
            ICreditOracle.Entry storage entry = entries[subsequent];
            rollingSum += entry.rate;
            subsequent = entry.predecessor;
        }
        
        uint256 rateAverage = rollingSum / count;
        uint256 timespan = timestamp - subsequent;
        
        return (rateAverage, timespan, subsequent);
    }
}
