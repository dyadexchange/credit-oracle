pragma solidity ^0.8.13;

import { ICreditOracle } from '@interfaces/ICreditOracle.sol';

contract ExponentialMovingAverageStrategy {
    // Multiplier for precision, since Solidity doesn't support floating point
    uint256 private constant PRECISION = 1e18;
    
    function query(
        ICreditOracle.Market memory entries,
        uint256 timestamp,
        uint256 count
    ) 
        public view 
        returns (uint256, uint256, uint256) 
    {
        uint256 subsequent = timestamp;
        uint256 ema = entries[subsequent].rate;
        
        // Smoothing factor (α) = 2/(count + 1)
        uint256 alpha = (2 * PRECISION) / (count + 1);
        
        for (uint256 x = 1; x < count; x++) {
            subsequent = entries[subsequent].predecessor;
            ICreditOracle.Entry storage entry = entries[subsequent];
            
            // EMA = α * current_rate + (1 - α) * previous_EMA
            ema = (alpha * entry.rate + (PRECISION - alpha) * ema) / PRECISION;
        }
        
        uint256 timespan = timestamp - subsequent;
        
        return (ema, timespan, subsequent);
    }
}
