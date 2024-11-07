pragma solidity ^0.8.13;

interface ILendingPool {
   function getReserveData(address asset) external view returns (
       uint256 liquidityRate,
       uint256 stableBorrowRate,
       uint256 variableBorrowRate,
       uint256 liquidityIndex,
       uint256 variableBorrowIndex
   );
}


