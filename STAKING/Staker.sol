//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  uint256 public constant threshold = 0.01 ether;

  uint256 public deadline = block.timestamp + 3 minutes;

  mapping ( address => uint256 ) public balances;

  bool private openForWithdraw;

  bool private isExecuted;

  event Stake(address indexed staker, uint256 indexed amount);

  modifier canStake {
    require(block.timestamp <= deadline, "The deadline has passed!");
    _;
  }

  modifier canExecute {
    require(block.timestamp > deadline && !isExecuted, "The deadline has not yet passed, or the function has already been executed!");
    _;
  }

  modifier haveFunds(address _address) { 
    require (balances[_address] > 0, "You don't have funds in the Staker contract!"); 
    _;
  }

  modifier canWithdraw {
    require(openForWithdraw == true || block.timestamp > deadline, "You can not withdraw your funds at the moment!");
    _;
  }

////////////////////////////////////////////////////////

  constructor(address exampleExternalContractAddress) {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

////////////////////////////////////////////////////////

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  function stake() public payable canStake {
      balances[msg.sender] += msg.value;
  
      emit Stake(msg.sender, msg.value);
  }


  // After some `deadline` allow anyone to call an `execute()` function
  function execute() external canExecute {
      isExecuted = true;
      if(address(this).balance >= threshold) {
        exampleExternalContract.complete{value: address(this).balance}();
      } else {
        openForWithdraw = true;
      }
  }

  // if the `threshold` was not met, allow everyone to call a `withdraw()` function
  // Add a `withdraw(address payable)` function lets users withdraw their balance
  function withdraw(address payable staker) external haveFunds(staker) canWithdraw {
      uint256 funds = balances[staker];
      balances[staker] = 0;
      (bool success, ) = staker.call{value: funds}("");
      require(success, "ETH withdrawal failed!");
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256) {
    if(block.timestamp >= deadline) {
      return 0;
    } else return deadline - block.timestamp;
  }

  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable 
    canStake {
      stake();
  }
}
