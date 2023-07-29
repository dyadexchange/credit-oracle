pragma solidity ^0.8.13;

import { ICreditRegistry } from '@interfaces/ICreditRegistry.sol';

interface ICreditOracle is ICreditRegistry {

    struct Market {
        uint256 lastTimestamp;
        mapping(uint256 => Entry) entries; 
    }
  
    struct Entry {
        uint256 rate;
        uint256 predecessor;
    }

    error InvalidRegistry();
}