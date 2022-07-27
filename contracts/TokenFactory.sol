// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetFixedSupplyUpgradeable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract FactoryClone {
    address immutable tokenImplementation;

    event TokenCreated(
        address indexed token,
        string name,
        string symbol,
        uint totalSupply
    );

    constructor() {
        tokenImplementation = address(new ERC20PresetFixedSupplyUpgradeable());
    }

    function createToken(string calldata name, string calldata symbol, uint256 initialSupply) external returns (address) {
        address clone = Clones.clone(tokenImplementation);
        initialSupply = initialSupply * 1e18;
        ERC20PresetFixedSupplyUpgradeable(clone).initialize(name, symbol, initialSupply, msg.sender);
        
        emit TokenCreated(clone, name, symbol, initialSupply);
        return clone;
    }
}