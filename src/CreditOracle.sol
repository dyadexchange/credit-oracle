pragma solidity ^0.8.13;

import { ICreditOracle } from '@interfaces/ICreditOracle.sol';
import { ICreditStrategy } from '@interfaces/ICreditStrategy.sol';

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

    function queryRate(
        Term duration, 
        address asset, 
        address strategy,
        uint256 timestamp,
        uint256 entries
    ) 
        public view 
        returns (uint256, uint256, uint256)
    {
        uint256 strategyRate;
        uint256 lastEntryIndex;
        uint256 strategySeriesTime;

        (strategyRate, strategySeriesTime, lastEntryIndex) = ICreditStrategy(strategy).query(
            _markets[asset][duration],
            timestamp,
            entries
        );

        return (strategyRate, strategySeriesTime, lastEntryIndex);
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