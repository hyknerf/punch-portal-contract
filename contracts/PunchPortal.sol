// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract PunchPortal {
    // store all address that have been interacting with the contract
    mapping(address => uint256) public addressPunchCounts;

    // store the last punch timestamp for each address
    mapping(address => uint256) public lastPunchAt;

    struct Punch {
        address puncher;
        string message;
        uint256 timestamp;
    }

    uint256 totalPunches;
    uint256 private seed;
    uint8 private immutable winningRate;
    Punch[] punches;

    event NewPunch(address indexed from, uint256 timestamp, string message);

    constructor(uint8 _winningRate) payable {
        console.log("I am a smart contract, I let people to punch the deployer of this contract");
        seed = (block.timestamp + block.difficulty) % 100;
        winningRate = _winningRate;
    }

    function punch(string memory _message) public {
        // set cooldown for 30 seconds on each address to prevent abuse
        require(
            lastPunchAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30 secs"
        );

        lastPunchAt[msg.sender] = block.timestamp;

        // increase totalPunches counter
        totalPunches += 1;

        // increase punch counter for address
        addressPunchCounts[msg.sender] += 1;
        console.log(
            "%s punched me! Total punch: %s",
            msg.sender,
            addressPunchCounts[msg.sender]
        );

        // insert address to store last punch timestamp
        punches.push(Punch(msg.sender, _message, block.timestamp));

        // simulate randomeness, this is not really random as everything in
        // blockchain are deterministic
        // proper solution might need to integrate with oracle such as Chainlink
        seed = (block.timestamp + block.difficulty) % 100;
        console.log("Random # generated: %d", seed);

        // give prize to puncher if generated seed are lower than winningRate
        if (seed <= winningRate) {
            console.log("%s got the jackpot!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Prize value is greater than contract balance"
            );

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Balance on contract dried");
        }

        emit NewPunch(msg.sender, block.timestamp, _message);
    }

    function getTotalPunches() public view returns (uint256) {
        console.log("We have %d total punches!", totalPunches);
        return totalPunches;
    }

    function getAllPunches() public view returns (Punch[] memory) {
        return punches;
    }
}
