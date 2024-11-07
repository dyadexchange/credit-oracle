pragma solidity ^0.8.13;

import "@intefaces/ICreditOracle.sol";
import "@interfaces/ICreditProvider.sol";

contract AaveProvider is ICreditProvider {
   address public controller;
   
   mapping(address => bool) public registeredMarkets;
   mapping(address => uint256) public lastAttestation;

   ICreditOracle public immutable creditOracle;
   ILendingPoolAddressesProvider public immutable addressProvider;
    
   uint256 constant ATTESTATION_THRESHOLD = 14 days;

   constructor(
       address _controller
       address _creditOracle,
       address _addressProvider,
   ) {
       controller = _controller;
       creditOracle = ICreditOracle(_creditOracle);
       addressProvider = ILendingPoolAddressesProvider(_addressProvider);
   }
   
   modifier onlyController() {
       require(msg.sender == controller, "Not controller");
       _;
   }
   
   function setController(address _controller) external onlyController {
       controller = _controller;
   }
   
   function registerMarket(address asset) external onlyController {
       registeredMarkets[asset] = true;
   }
   
   function attestRate(
       address asset,
       Term duration,
       uint256 rate
   ) external onlyController {
       require(registeredMarkets[asset], "Market not registered");
       
       creditOracle.log(
           asset,
           duration,
           rate
       );
   }
   
   function updateFromAave(address asset) external {
       require(registeredMarkets[asset], "Market not registered");
       require(
           block.timestamp >= lastAttestation[asset] + ATTESTATION_THRESHOLD,
           "Too early for attestation"
       );

       ILendingPool pool = ILendingPool(addressProvider.getLendingPool());
       
       (,,uint256 variableBorrowRate,,,) = pool.getReserveData(asset);

       lastAttestation[asset] = block.timestamp;
       
       attestRate(asset, IDomainObjects.Term.PERPETUAL, variableBorrowRate);
  }

}

