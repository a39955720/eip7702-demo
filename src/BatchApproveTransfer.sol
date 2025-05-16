// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BatchApproveTransfer {
    struct Call {
        address to;
        uint256 value;
        bytes data;
    }

    uint256 public nonce;

    function execute(Call[] calldata calls) external payable {
        require(msg.sender == address(this), "Not authority");
        for (uint256 i = 0; i < calls.length; i++) {
            (bool ok,) = calls[i].to.call{value: calls[i].value}(calls[i].data);
            require(ok, "call failed");
        }
        nonce++;
    }
}
