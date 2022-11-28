// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './Tether.sol';
import './RWD.sol';

//reward token contract
contract DecentralBank {
    string public name= 'Decentral Bank';
    address public owner;
    
    Tether public tether;
    RWD public  rwd;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaked;


    constructor(RWD _rwd, Tether _tether){
        tether=_tether;
        rwd= _rwd;
        owner=msg.sender;

    }
    //staking functio
    function depositToken(uint _amount) public{
        require(_amount >0 , "amount cannot be zero");
        //transfer tether token to this contract for staking
        tether.transferFrom(msg.sender, address(this), _amount);

        stakingBalance[msg.sender]+=_amount;

        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }
        isStaked[msg.sender]=true;
        hasStaked[msg.sender]=true;

    }
    function issueTokens() public{
        require(msg.sender==owner,"caller is not owner");
        for(uint i=0; i<stakers.length; i++){
            address recipient= stakers[i];
            uint balance= stakingBalance[recipient]/9;
            if(balance>0){
                rwd.transfer(recipient, balance);
            }

        }
    }
    function unstakingTokens() public{
        uint balance = stakingBalance[msg.sender];
        require(balance > 0, "staking balance cannot be less zero");
        tether.transfer(msg.sender, balance);
        stakingBalance[msg.sender]=0;
        isStaked[msg.sender]=false;

    }

}