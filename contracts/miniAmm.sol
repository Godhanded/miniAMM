//SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract playAMM{
    constructor(address tokenAddr){
        owner=msg.sender;
        token= tokenAddr;
    }
    uint256 netEth;
    uint256 netGtoken; 
    uint256 k;

    address owner;
    address token;

    error failed(string);
    /**
      @dev using constant product algorith, limited to only one token for now,
           must have approved contract to spend, on front-end?
      @notice constant product algo: X * Y = k*/
    function deposit(uint256 amount, uint256 eth) external payable 
    {
        uint256 newEth= netEth + eth;
        uint256 newGtoken= netGtoken + amount;
        uint256 newk= newEth*newGtoken;
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        if(newk >= k)
        {
            (newk>k)? withk(amount, eth, newk): withoutk(amount, eth);
        }else{
            revert failed("Must be less thank k");
        }

        
    }

    function swap(uint256 amount) external
    {

    }

    function withk(uint256 amount, uint256 eth, uint256 newk) internal
    {
        netEth+=eth;
        netGtoken+=amount;
        k=newk;
    }
    function withoutk(uint256 amount, uint256 eth) internal
    {
        netEth+=eth;
        netGtoken+=amount;
    }
}