// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ICreature {
    function attack(uint256 _damage) external;
}

contract Attacker {
    ICreature target;

    constructor(address _target) {
        target = ICreature(_target);
    }

    function attack(uint256 _damage) external {
        target.attack(_damage);
    }
}