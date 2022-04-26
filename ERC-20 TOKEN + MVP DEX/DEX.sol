pragma solidity >=0.8.0 <0.9.0;
// SPDX-License-Identifier: MIT
import "./TST_TOKEN.sol";

contract DEX {

    IERC20 public token;

    using SafeMath for uint256;

    constructor() {
        token= IERC20(0x232be76084bd5157Ca678A09C691e45f60BB5db2);
    }

    function buy() payable public {
        uint amount=msg.value;
        uint dexBalance=token.balanceOf(address(this));
        require(amount>0, "Amount should be bigger than 0");
        require(dexBalance>amount, "Not enough tokens in DEX");
        token.transfer(msg.sender, amount);
        emit Bought(msg.sender, amount);
    }

    function sell(uint amount) public {
        require(amount>0, "Amount should be bigger than 0");
        uint allowance=token.allowance(msg.sender, address(this));
        require (allowance >= amount, "User didn't allow DEX to send this amount");
        token.transferFrom(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amount);
        emit Sold(msg.sender, amount);
    }

    event Bought(address buyer, uint tokenAmount);
    event Sold(address seller, uint tokenAmount);
}