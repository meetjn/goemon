// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {IPlugin} from "src/IPlugin.sol";

/**
 * @title Core
 * @dev A contract that maintains a registry of plugins and can dynamically call their functions
 */
contract Core is Ownable {
    // Mapping of plugin IDs to their contract addresses
    mapping(uint256 => address) private plugins;
    
    // Counter for tracking the next plugin ID
    uint256 private nextPluginId;
    
    // Events
    event PluginAdded(uint256 indexed pluginId, address indexed pluginAddress);
    event PluginUpdated(uint256 indexed pluginId, address indexed pluginAddress);
    event PluginRemoved(uint256 indexed pluginId);
    event PluginExecuted(uint256 indexed pluginId, uint256 input, uint256 result);
    
    /**
     * @dev Constructor that sets the owner to the deployer
     */
    constructor() Ownable(msg.sender) {
        nextPluginId = 1; // Start plugin IDs at 1
    }
    
    /**
     * @dev Adds a new plugin to the registry
     * @param pluginAddress The address of the plugin contract
     * @return pluginId The ID assigned to the new plugin
     */
    function addPlugin(address pluginAddress) external onlyOwner returns (uint256 pluginId) {
        require(pluginAddress != address(0), "Plugin address cannot be zero");
        
        // Ensure the address implements the IPlugin interface
        require(
            IPlugin(pluginAddress).performAction(0) == IPlugin(pluginAddress).performAction(0),
            "Address must implement IPlugin interface"
        );
        
        pluginId = nextPluginId;
        plugins[pluginId] = pluginAddress;
        nextPluginId++;
        
        emit PluginAdded(pluginId, pluginAddress);
        return pluginId;
    }
    
    /**
     * @dev Updates an existing plugin in the registry
     * @param pluginId The ID of the plugin to update
     * @param pluginAddress The new address of the plugin contract
     */
    function updatePlugin(uint256 pluginId, address pluginAddress) external onlyOwner {
        require(pluginId > 0 && pluginId < nextPluginId, "Plugin ID does not exist");
        require(plugins[pluginId] != address(0), "Plugin was removed or never existed");
        require(pluginAddress != address(0), "Plugin address cannot be zero");
        
        // Ensure the address implements the IPlugin interface
        require(
            IPlugin(pluginAddress).performAction(0) == IPlugin(pluginAddress).performAction(0),
            "Address must implement IPlugin interface"
        );
        
        plugins[pluginId] = pluginAddress;
        
        emit PluginUpdated(pluginId, pluginAddress);
    }
    
    /**
     * @dev Removes a plugin from the registry
     * @param pluginId The ID of the plugin to remove
     */
    function removePlugin(uint256 pluginId) external onlyOwner {
        require(pluginId > 0 && pluginId < nextPluginId, "Plugin ID does not exist");
        require(plugins[pluginId] != address(0), "Plugin was already removed or never existed");
        
        delete plugins[pluginId];
        
        emit PluginRemoved(pluginId);
    }
    
    /**
     * @dev Executes a plugin action with the given input
     * @param pluginId The ID of the plugin to execute
     * @param input The input to pass to the plugin's action
     * @return result The result returned by the plugin's action
     */
    function executePlugin(uint256 pluginId, uint256 input) external returns (uint256 result) {
        address pluginAddress = plugins[pluginId];
        require(pluginAddress != address(0), "Plugin does not exist");
        
        result = IPlugin(pluginAddress).performAction(input);
        
        emit PluginExecuted(pluginId, input, result);
        return result;
    }
    
    /**
     * @dev Gets the address of a plugin
     * @param pluginId The ID of the plugin
     * @return The address of the plugin
     */
    function getPluginAddress(uint256 pluginId) external view returns (address) {
        return plugins[pluginId];
    }
    
    /**
     * @dev Gets the next plugin ID that will be assigned
     * @return The next plugin ID
     */
    function getNextPluginId() external view returns (uint256) {
        return nextPluginId;
    }
}