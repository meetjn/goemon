# Solidity Modular Plugin System with Vault Creation Plugin

The project uses Foundry framework for seamlessly working with solidity smart contracts and testing.

## Overview

This project implements a modular plugin system in Solidity that allows for dynamic extension of functionality through plugins. The core architecture consists of:

- **Core Contract**: A central registry that manages plugins and provides dynamic dispatch capabilities
- **Plugin Interface**: A standardized interface that all plugins must implement
- **Example Plugins**:
  - A simple plugin that multiplies input by a factor
  - A vault creation plugin that creates and tracks vaults on-chain

## Requirements

- [Foundry](https://getfoundry.sh/) - Ethereum development toolbox
- Solidity ^0.8.19

## Project Structure

```
├── src/
│   ├── Core.sol           # Main contract with plugin registry
│   ├── IPlugin.sol        # Plugin interface definition
│   ├── ExamplePlugin.sol  # Simple example plugin
│   └── VaultPlugin.sol    # Vault creation plugin
├── test/                  # Test files
├── lib/                   # Dependencies (OpenZeppelin)
└── foundry.toml           # Foundry configuration
```

## Setup Instructions

1. **Clone the repository**

```bash
git clone <repository-url>
cd goemon-assignment
```

2. **Install dependencies**

Install Foundry if you haven't already:

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Install project dependencies:

```bash
forge install
```

## Compilation

Compile the smart contracts with Foundry:

```bash
forge build
```

## Testing

Run the test suite:

```bash
forge test
```

For verbose output:

```bash
forge test -vvv
```

Check test coverage:

```bash
forge coverage
```

## Contract Overview

### Core.sol

The Core contract maintains a registry of plugins and enables dynamic dispatch to them:

- **Registry Management**: Add, update, or remove plugins (owner-only)
- **Dynamic Dispatch**: Execute functionality from registered plugins
- **Access Control**: Uses OpenZeppelin's Ownable for permissions

### IPlugin.sol

Defines the standard interface that all plugins must implement:

- `performAction(uint256 input) -> uint256`: The standard function all plugins implement

### ExamplePlugin.sol

A simple plugin implementation that multiplies input by a configurable factor:

- Demonstrates the basic plugin architecture
- Returns `input * multiplier`

### VaultPlugin.sol

A plugin that creates and manages vaults on-chain:

- Creates unique vaults with owner and balance information
- Returns the vault ID for future reference
- Maintains registry of all created vaults

## Usage Examples

### Deploying the System

1. Deploy the Core contract
2. Deploy plugin contracts (ExamplePlugin and VaultPlugin)
3. Register plugins with the Core contract (owner only)

### Using Plugins

Users can interact with plugins through the Core contract:

```solidity
// Execute example plugin with input 10
uint256 result = core.executePlugin(examplePluginId, 10);

// Create a vault with initial balance of 100
uint256 vaultId = core.executePlugin(vaultPluginId, 100);
```

## Extending the System

To create a new plugin:

1. Create a contract that implements the IPlugin interface
2. Deploy the plugin contract
3. Register it with the Core contract

## License

This project is licensed under MIT.
