// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal{
    uint totalWaves;

    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    // address -> uint mapping. key is address, uint is value
    mapping(address => uint256) public lastWavedAt;

    constructor() payable{
        console.log("POGGERS. SMART. CONTRACT. YES.");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public{
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30s"
        );
        // update current timestamp for user.
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;

        console.log("%s has waved", msg.sender, _message);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        // Generate new seed every wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        if (seed <= 50){
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require ( 
                prizeAmount <= address(this).balance,
                "Trying to withdaw more than the contract balance"
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw from contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory){
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

}