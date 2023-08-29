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
		_log_entry(0);
	}

	function testQueryTimeWeighted() public {
		uint256 startTimestamp = block.timestamp;
		uint256[7] memory interest_rates = [
			uint256(100 gwei),
			uint256(101 gwei),
			uint256(105 gwei),
			uint256(101 gwei),
			uint256(100 gwei),
			uint256(99 gwei),
			uint256(105 gwei)
		];

		for (uint256 x = 0; x < interest_rates.length; x++) {
			_log_entry(interest_rates[x]);

			vm.warp(block.timestamp + 1 weeks);
		}

		(uint256 value, uint256 delta, uint256 ts) = oracle.queryTimeWeighted(
			MARKET_ADDRESS,
			ICreditRegistry.Term.ONE_MONTHS,
			startTimestamp,
			7
		);
	}

	function _log_entry(uint256 rate) public {
		/*  ------ REGISTRY ------ */
		vm.startPrank(REGISTRY_ADDRESS);
			oracle.log(MARKET_ADDRESS, ICreditRegistry.Term.ONE_MONTHS, rate);
		vm.stopPrank();
		/*  --------------------- */
	}
}