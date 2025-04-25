// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IPlugin {
    /**
     * @dev Executes the plugin action with the provided input and returns a result.
     * @param input The input parameter for the plugin action
     * @return Result of the plugin action
     */
    function performAction(uint256 input) external returns (uint256);
}