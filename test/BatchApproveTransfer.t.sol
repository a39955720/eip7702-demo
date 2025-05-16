// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/BatchApproveTransfer.sol";
import "../src/MockERC20.sol";
import "../src/MockUniswapRouter.sol";

contract BatchApproveTransferTest is Test {
    BatchApproveTransfer impl;
    MockERC20 token;
    MockUniswapRouter router;

    address alice;
    uint256 alicePk;
    address recipient;

    function setUp() public {
        alicePk = 0xA11CE;
        alice = vm.addr(alicePk);
        recipient = address(0x1);

        router = new MockUniswapRouter();
        impl = new BatchApproveTransfer();
        token = new MockERC20();
        token.mint(alice, 1000 ether);
    }

    function test_7702BatchApproveTransfer() public {
        vm.signAndAttachDelegation(address(impl), alicePk);

        BatchApproveTransfer.Call[] memory calls = new BatchApproveTransfer.Call[](2);

        calls[0] = BatchApproveTransfer.Call({
            to: address(token),
            value: 0,
            data: abi.encodeWithSignature("approve(address,uint256)", router, 100 ether)
        });

        calls[1] = BatchApproveTransfer.Call({
            to: address(router),
            value: 0,
            data: abi.encodeWithSignature("exactInputSingle(address,uint256)", address(token), 42 ether)
        });

        vm.startPrank(alice);
        BatchApproveTransfer(payable(alice)).execute(calls);
        vm.stopPrank();

        assertEq(token.allowance(alice, address(router)), 100 ether - 42 ether, "approve failed");
        assertEq(token.balanceOf(recipient), 42 ether, "transfer failed");
        assertEq(token.balanceOf(alice), 1000 ether - 42 ether, "alice balance error");
    }
}
