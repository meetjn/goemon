// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IPlugin} from "src/IPlugin.sol";

/**
 * @title VaultPlugin
 * @dev A plugin that creates vaults and assigns them to the caller
 */
contract VaultPlugin is IPlugin {
    // Struct to store vault information
    struct Vault {
        address owner;
        uint256 balance;
        bool exists;
    }
    
    // Mapping of vault IDs to vault information
    mapping(uint256 => Vault) public vaults;
    
    // Counter for tracking the next vault ID
    uint256 private nextVaultId;
    
    // Events
    event VaultCreated(uint256 indexed vaultId, address indexed owner, uint256 initialBalance);
    event ActionPerformed(uint256 input, uint256 result);
    
    /**
     * @dev Constructor to initialize the vault plugin
     */
    constructor() {
        nextVaultId = 1; // Start vault IDs at 1
    }
    
    /**
     * @dev Implements the IPlugin interface by creating a new vault
     * @param input The initial balance for the vault
     * @return The ID of the newly created vault
     */
    function performAction(uint256 input) external override returns (uint256) {
        uint256 vaultId = createVault(msg.sender, input);
        
        emit ActionPerformed(input, vaultId);
        return vaultId;
    }
    
    /**
     * @dev Creates a new vault for the specified owner with an initial balance
     * @param owner The address that will own the vault
     * @param initialBalance The initial balance to set for the vault
     * @return vaultId The ID of the newly created vault
     */
    function createVault(address owner, uint256 initialBalance) internal returns (uint256 vaultId) {
        require(owner != address(0), "Owner cannot be zero address");
        
        vaultId = nextVaultId;
        
        vaults[vaultId] = Vault({
            owner: owner,
            balance: initialBalance,
            exists: true
        });
        
        nextVaultId++;
        
        emit VaultCreated(vaultId, owner, initialBalance);
        return vaultId;
    }
    
    /**
     * @dev Gets information about a specific vault
     * @param vaultId The ID of the vault to query
     * @return owner The address of the vault owner
     * @return balance The balance stored in the vault
     * @return exists Whether the vault exists
     */
    function getVault(uint256 vaultId) external view returns (address owner, uint256 balance, bool exists) {
        Vault storage vault = vaults[vaultId];
        return (vault.owner, vault.balance, vault.exists);
    }
    
    /**
     * @dev Gets the total number of vaults that have been created
     * @return The number of vaults (equal to nextVaultId - 1)
     */
    function getVaultCount() external view returns (uint256) {
        return nextVaultId - 1;
    }
}