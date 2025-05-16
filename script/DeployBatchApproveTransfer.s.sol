// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Script, console} from "forge-std/Script.sol";
import {BatchApproveTransfer} from "../src/BatchApproveTransfer.sol";

contract DeployBatchApproveTransfer is Script {
    function run() public {
        // vm.startBroadcast();

        new BatchApproveTransfer();

        // vm.stopBroadcast();
    }
}
