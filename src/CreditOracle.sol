pragma solidity ^0.8.13;

import { ICreditOracle } from '@interfaces/ICreditOracle.sol';
import { ICreditStrategy } from '@interfaces/ICreditStrategy.sol';

contract CreditOracle is ICreditOracle {

    mapping (address => Provider) _providers;

    address _controller;

    constructor(address controller) {
        _controller = controller;
    }

    modifier onlyController() {
        if (msg.sender != controller()) {
            revert InvalidRegistry();
        }
        _;
    }

    modifier onlyProvider() {
        if (!_providers[msg.sender].authenicated) {
            revert InvalidRegistry();
        }
        _;
    }

    function controller() public view returns (address) {
        return _controller;
    }

    function entry(
        address provider,
        address asset, 
        Term duration, 
        uint256 timestamp
    )
        public view
        returns (Entry memory)
    {
        return _providers[provider].market[asset][duration].entries[timestamp];
    }

    function queryRate(
        address asset, 
        address strategy,
        address provider,
        Term duration, 
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
            _providers[provider].market[asset][duration],
            timestamp,
            entries
        );

        return (strategyRate, strategySeriesTime, lastEntryIndex);
    }

    function log(address asset, Term duration, uint256 rate)  
        public
        onlyProvider
    {
        Market storage market = _providers[msg.sender].market[asset][duration];

        uint256 subsequentTimestamp = block.timestamrp;
        uint256 previousTimestamp = market.lastTimestamp;

        Entry storage entry = market.entries[subsequentTimestamp];

        entry.rate = rate;
        entry.predecessor = previousTimestamp;
        market.lastTimestamp = subsequentTimestamp;

        emit Log(msg.sender, asset, duration, rate);
    }

    function configureController(address controller) onlyController public {
        _controller = controller;
    }

    function registerProvider(address provider) onlyController public {
        _providers[provider].authenicated = true;

        emit Register(provider);
    }

    function unregisterProvider(address provider) onlyController public {
        _providers[provider].authenicated = false;

        emit Unregister(provider);
    }

}