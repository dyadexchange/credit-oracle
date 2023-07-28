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

}