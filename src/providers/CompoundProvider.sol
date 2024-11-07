import "@intefaces/ICreditOracle.sol";
import "@interfaces/ICreditProvider.sol";

contract CompoundProvider is ICreditProvider {
   address public controller;
   
   mapping(address => address) public cTokenToUnderlying;
   mapping(address => uint256) public lastAttestation;
   
   ICreditOracle public immutable creditOracle;

   uint256 constant ATTESTATION_THRESHOLD = 14 days;
   
   constructor(address _creditOracle, address _controller) {
       controller = _controller;
       creditOracle = ICreditOracle(_creditOracle);
   }
   
   modifier onlyController() {
       require(msg.sender == controller, "Not controller");
       _;
   }
   
   modifier onlyMarket(address cToken) {
       require(cTokenToUnderlying[cToken] != address(0), "Not registered");
       _;
   }
   
   function setController(address _controller) external onlyController {
       controller = _controller;
   }
   
   function registerMarket(
       address cToken,
       address underlying
   ) external onlyController {
       cTokenToUnderlying[cToken] = underlying;
   }
   
   function attestRate(
       address cToken,
       IDomainObjects.Term duration,
       uint256 rate
   ) external onlyController onlyMarket(cToken) {
       address underlying = cTokenToUnderlying[cToken];
       
       creditOracle.log(underlying, duration, rate);
   }
   
   function updateFromCompound(address cToken) external {
       require(
           block.timestamp >= lastAttestation[cToken] + ATTESTATION_THRESHOLD,
           "Too early for attestation"
       );

       ICToken market = ICToken(cToken);
       uint256 rate = market.borrowRatePerBlock();
       
       lastAttestation[cToken] = block.timestamp;
       
       attestRate(cToken, IDomainObjects.Term.PERPETUAL, rate);
   }

}

