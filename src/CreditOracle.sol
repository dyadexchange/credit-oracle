pragma solidity ^0.8.13;

import { ICreditOracle } from '@interfaces/ICreditOracle.sol';
import { ICreditRegistry } from '@interfaces/ICreditRegistry.sol';

contract CreditOracle is ICreditOracle {

    mapping (address => mapping(Term => Market)) _markets;

    address _registry;

    constructor(address registry) {
        _registry = registry;
    }

    modifier onlyRegistry() {
        if (msg.sender != registry()) {
            revert InvalidRegistry();
        }
        _;
    }

    function registry() public view returns (address) {
        return _registry;
    }

    function entry(address asset, Term duration, uint256 timestamp)
        public view
        returns (Entry memory)
    {
        return _markets[asset][duration].entries[timestamp];
    }

    function queryTimeWeighted(
        address asset, 
        Term duration, 
        uint256 timestamp,
        uint256 entries
    ) 
        public view 
        returns (uint256, uint256, uint256)
    {
        uint256 queryNum;
        uint256 queryDenom;
        uint256 subsequent = timestamp;

        Market storage market = _markets[asset][duration];

        for (uint256 x = 0; x < entries; x++) {
            Entry storage entry = market.entries[subsequent];

            uint256 deltaTime = subsequent - entry.predecessor;

            queryNum += deltaTime * entry.rate;
            queryDenom += deltaTime;

            subsequent = entry.predecessor;
        }

        uint256 rateWeighted = queryNum / queryDenom;

        return (rateWeighted, queryDenom, subsequent);
    }

    function log(address asset, Term duration, uint256 rate)  
        public
        onlyRegistry
    {
        Market storage market = _markets[asset][duration];

        uint256 subsequentTimestamp = block.timestamp;
        uint256 previousTimestamp = market.lastTimestamp;

        Entry storage entry = market.entries[subsequentTimestamp];

        entry.rate = rate;
        entry.predecessor = previousTimestamp;
        market.lastTimestamp = subsequentTimestamp;

        emit Log(asset, duration, rate);
    }

}