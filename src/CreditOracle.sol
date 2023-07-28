pragma solidity ^0.8.19;

import { ICreditOracle } from '@interfaces/ICreditOracle.sol';

contract CreditOracle is ICreditOracle {

    mapping (address => mapping(Term => Entry)) _entries;
    mapping (address => mapping(Term => uint256)) _timestamps;

    address _registry;

    constructor(address registry) {
        _registry = registry;
    }

    modifier onlyRegistry() {
        if (msg.sender != registry()) {
            revert InvalidRegistry();
        }
    }

    function registry() public view returns (address) {
        return _registry;
    }

    function log(address asset, Term duration, uint256 interest) public onlyRegistry {
        uint256 subsequentTimestamp = block.timestamp;
        uint256 previousTimestamp = _timestamps[asset][duration];

        Entry storage entry = _entries[duration][subsequentTimestamp];

        _timestamps[asset][duration] = subsequentTimestamp;

        entry.predecessor = previousTimestamp;
        enity.rate = interest;
    }

}