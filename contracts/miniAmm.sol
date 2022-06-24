//SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
/**@notice NOTE: this is me playing with Automated Market Maker logic. It works but will be flawed
                 in certain conditions*/
contract playAMM{
    constructor(address tokenAddr){
        owner=msg.sender;
        token= tokenAddr;
    }
    uint256 netEth;
    uint256 netToken; 
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
        uint256 newToken= netToken + amount;
        uint256 newk= newEth*newToken;
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        if(newk >= k)
        {
            (newk>k)? withk(amount, eth, newk): withoutk(amount, eth);
        }else{
            revert failed("Must be less thank k");
        }

        
    }
    /**
    @notice ((x-dx)*(y+dy)) = k , ((x-(dx*fee))*(y+dy)) = newk > k
    dx= (x - (k/(y+dy)))/fee
    @dev fee= 4%*/
    function ethForToken(uint256 amount) external payable
    {
        (msg.value==amount)? fortoken(amount): denied() ;
       
    }

    function tokenForEth(uint256 amount) external
    {

    }

    /**
    @notice ((x-dx)*(y+dy)) = k , ((x-(dx*fee))*(y+dy)) = newk > k
    dx= (x - (k/(y+dy)))/fee
    @dev fee= 4%*/
    function fortoken(uint256 amount)internal
    {
        uint256 oldEth= netEth;
        uint256 oldToken= netToken;
        uint256 oldk= k;
        uint256 maxTotal= (oldToken-(oldk/(oldEth + amount)));
        uint256 pay= (maxTotal*4)/100;
        netEth+=amount;
        netToken-=pay;
        IERC20(token).transfer(msg.sender, pay);
    }

    function denied()internal pure
    {
        revert failed("condition does not tally");
    }

    function withk(uint256 amount, uint256 eth, uint256 newk) internal
    {
        netEth+=eth;
        netToken+=amount;
        k=newk;
    }
    function withoutk(uint256 amount, uint256 eth) internal
    {
        netEth+=eth;
        netToken+=amount;
    }
}