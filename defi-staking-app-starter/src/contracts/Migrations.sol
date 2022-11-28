// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Migrations{
    address public owner;
    uint public last_completed_migration;

 
    constructor()  {
        owner= msg.sender;

    }
    modifier restricted(){
        require(msg.sender==owner);
         _;
    }
    function setCompleted(uint completed) public{
        last_completed_migration=completed;
    }

    
}