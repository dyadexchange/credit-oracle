pragma solidity ^0.8.13;

import "@interfaces/IDomainObjects.sol";

interface ICreditProvider {
   function attestRate(
       address asset,
       IDomainObjects.Term duration,
       uint256 rate
   ) external;
}
