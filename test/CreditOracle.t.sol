pragma solidity 0.8.15;

import { Test } from '@forge-std/Test.sol';
import { CreditOracle } from '@core/CreditOracle.sol';

contract CreditOracleTest {

	CreditOracle oracle;

	address REGISTRY_ADDRESS = 0x95A2b07eB236110719975625CeE026ffe2b02799;
 	
	function setUp() {
		oracle = new CreditOracle(REGISTRY_ADDRESS);
	}

	function testOwnership() {}

	function testQueryTimeWeighted() {}

}