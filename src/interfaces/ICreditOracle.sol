pragma solidity ^0.8.19;

interface ICreditOracle {

    enum Term { 1_MONTHS, 3_MONTHS, 6_MONTHS, 12_MONTHS }
  
    struct Entry {
        uint256 rate;
        uint256 predecessor;
    }

}