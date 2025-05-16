// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/BatchApproveTransfer.sol";
import "../src/MockERC20.sol";

contract BatchApproveTransferTest is Test {
    BatchApproveTransfer impl;
    MockERC20 token;

    address alice;
    uint256 alicePk;
    address spender;
    address recipient;

    function setUp() public {
        // 產生測試帳戶
        alicePk = 0xA11CE;
        alice = vm.addr(alicePk);
        spender = address(0xBEEF);
        recipient = address(0xCAFE);

        // 部署合約
        impl = new BatchApproveTransfer();
        token = new MockERC20();
        token.mint(alice, 1000 ether);
    }

    function test_7702BatchApproveTransfer() public {
        // Alice 給自己設 delegation（vm.cheatcode, type-4 tx）
        vm.signAndAttachDelegation(address(impl), alicePk);

        // 批次呼叫
        BatchApproveTransfer.Call[] memory calls = new BatchApproveTransfer.Call[](2);

        // ERC20.approve(spender, 100 ether)
        calls[0] = BatchApproveTransfer.Call({
            to: address(token),
            value: 0,
            data: abi.encodeWithSignature("approve(address,uint256)", spender, 100 ether)
        });

        // ERC20.transfer(recipient, 42 ether)
        calls[1] = BatchApproveTransfer.Call({
            to: address(token),
            value: 0,
            data: abi.encodeWithSignature("transfer(address,uint256)", recipient, 42 ether)
        });

        // 代理執行
        vm.startPrank(alice);
        BatchApproveTransfer(payable(alice)).execute(calls);
        vm.stopPrank();

        // 檢查
        assertEq(token.allowance(alice, spender), 100 ether, "approve failed");
        assertEq(token.balanceOf(recipient), 42 ether, "transfer failed");
        assertEq(token.balanceOf(alice), 1000 ether - 42 ether, "alice balance error");
    }
}
