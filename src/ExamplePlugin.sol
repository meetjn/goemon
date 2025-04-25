// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IPlugin} from "src/IPlugin.sol";

/**
 * @title ExamplePlugin
 * @dev A simple example plugin that multiplies input by a constant factor
 */
contract ExamplePlugin is IPlugin {
    // The multiplier to apply to the input
    uint256 public immutable multiplier;
    
    // Event emitted when the plugin action is performed
    event ActionPerformed(uint256 input, uint256 result);
    
    /**
     * @dev Constructor that sets the multiplier
     * @param _multiplier The value to multiply inputs by
     */
    constructor(uint256 _multiplier) {
        require(_multiplier > 0, "Multiplier must be greater than zero");
        multiplier = _multiplier;
    }
    
    /**
     * @dev Implements the IPlugin interface by multiplying the input by the multiplier
     * @param input The value to multiply
     * @return The result of input * multiplier
     */
    function performAction(uint256 input) external override returns (uint256) {
        uint256 result = input * multiplier;
        
        emit ActionPerformed(input, result);
        return result;
    }
}