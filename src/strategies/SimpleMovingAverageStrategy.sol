pragma solidity ^0.8.13;

import { ICreditOracle } from '@interfaces/ICreditOracle.sol';

contract SimpleMovingAverageStrategy {
    function query(
        ICreditOracle.Market memory entries,
        uint256 timestamp,
        uint256 count
    ) 
        public view 
        returns (uint256, uint256, uint256) 
    {
        uint256 sum;
        uint256 subsequent = timestamp;
        
        // Calculate sum of last 'count' entries
        for (uint256 x = 0; x < count; x++) {
            ICreditOracle.Entry storage entry = entries[subsequent];
            sum += entry.rate;
            subsequent = entry.predecessor;
        }
        
        uint256 sma = sum / count;
        uint256 timespan = timestamp - subsequent;
        
        return (sma, timespan, subsequent);
    }
}

