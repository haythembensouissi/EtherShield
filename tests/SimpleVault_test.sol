// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "remix_tests.sol";
import "../contracts/SimpleVault.sol";

contract SimpleVaultTest {
    SimpleVault vault;

    function beforeAll() public {
        vault = new SimpleVault();
    }

    /// #value: 1000
    function test1_deposit() public payable {
        vault.deposit{value: 1000}();
        Assert.equal(vault.balances(address(this)), uint256(1000), "balance should be 1000");
    }

    function test2_withdraw() public {
        uint256 before = address(this).balance;
        vault.withdraw(400);
        Assert.equal(vault.balances(address(this)), uint256(600), "vault balance should be 600");
        Assert.equal(address(this).balance, before + 400, "should receive 400 wei");
    }

    function test3_overWithdrawReverts() public {
        try vault.withdraw(10_000) {
            Assert.ok(false, "should have reverted");
        } catch Error(string memory reason) {
            Assert.equal(reason, "insufficient", "wrong revert reason");
        }
    }

    function test4_zeroDepositReverts() public {
        try vault.deposit{value: 0}() {
            Assert.ok(false, "should have reverted");
        } catch Error(string memory reason) {
            Assert.equal(reason, "zero", "wrong revert reason");
        }
    }

    receive() external payable {}  // needed to receive ETH from withdraw
}