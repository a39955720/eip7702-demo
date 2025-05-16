// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockUniswapRouter {
    address public MockUniswapV3Pool = address(0x1);

    function exactInputSingle(address token, uint256 tokenIn) external {
        require(IERC20(token).transferFrom(msg.sender, MockUniswapV3Pool, tokenIn), "transferFrom failed");
    }
}
