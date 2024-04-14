pragma solidity ^0.8.13;

import { IDomainObjects } from '@interfaces/IDomainObjects.sol';

interface ICreditOracle is IDomainObjects {

    struct Provider {
        bool authenicated;
        mapping(address => mapping(Term => Market)) market;
    }

    struct Market {
        uint256 lastTimestamp;
        mapping(uint256 => Entry) entries; 
    }
  
    struct Entry {
        uint256 rate;
        uint256 predecessor;
    }

    error InvalidController();

    error InvalidProvider();

    event Log(address provider, address asset, Term duration, uint256 rate);
}