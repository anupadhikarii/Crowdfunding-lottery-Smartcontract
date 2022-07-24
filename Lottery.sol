// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract Lottery{
    address  manager;     //one who created contract or organizize lottery
    address payable[] participants;   

    constructor(){
        manager = msg.sender;
    }

    // Ether is re ceived and participant are added in participants array
    receive() external payable{
        participants.push(payable(msg.sender));
    }

    // To cheak current balance
    function currentBlance() public view returns(uint){
        require (msg.sender == manager);
        return address(this).balance;
    }

    // Generating random number 
    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,participants.length)));
    }

    //declaring winner
    function winner_of_lottery() public {
        require (msg.sender == manager);
        require (participants.length >= 3);
        address payable winner;
        uint number = random();
        uint _index = number % participants.length;
        winner = participants[_index];  
        winner.transfer(currentBlance());           // transfering Ether to the winner
        participants = new address payable[](0);    // clearing the participants array

    }
    }