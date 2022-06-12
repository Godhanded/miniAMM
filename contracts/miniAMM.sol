//SPDX-License-Identifier: 
pragma solidity ^0.8.5;

contract playAMM{
    constructor(){
        owner=msg.sender;
    }
    uint256 netEth;
    uint256 netGtoken;
    uint256 k;

    address owner;



    function deposit(uint256 amount, uint256 eth) external payable 
    {
        netEth+=eth;
        netGtoken+=amount;
        if(msg.sender==owner) k = amount*eth;
    }

    function swap(uint256 amount) external
    {

    }
}