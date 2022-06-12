//SPDX-License-Identifier: 
pragma solidity ^0.8.5;

contract playAMM{
    constructor(){

    }
    uint256 netEth;
    uint256 netGtoken;



    function deposit(uint256 amount, uint256 eth) external payable 
    {
        netEth+=eth;
        netGtoken+=amount;
    }

    function swap(uint256 amount) external
    {

    }
}