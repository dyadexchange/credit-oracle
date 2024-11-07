pragma solidity ^0.8.13;

interface ICToken {
   function borrowRatePerBlock() external view returns (uint256);
   function underlying() external view returns (address);
}
