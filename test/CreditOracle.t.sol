pragma solidity 0.8.15;

import { Test } from '@forge-std/Test.sol';
import { CreditOracle } from '@core/CreditOracle.sol';
import { ICreditRegistry } from '@interfaces/ICreditRegistry.sol';

contract CreditOracleTest is Test {

	CreditOracle oracle;

	address MARKET_ADDRESS = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
	address REGISTRY_ADDRESS = 0x95A2b07eB236110719975625CeE026ffe2b02799;
 	
	function setUp() public {
		oracle = new CreditOracle(REGISTRY_ADDRESS);
	}

	function testOwnership() public {
		/*  ------ REGISTRY ------ */
		vm.startPrank(REGISTRY_ADDRESS);
			oracle.log(MARKET_ADDRESS, ICreditRegistry.Term.ONE_MONTHS, 0);
		vm.stopPrank();
		/*  --------------------- */
	}

	function testQueryTimeWeighted() public {}

}