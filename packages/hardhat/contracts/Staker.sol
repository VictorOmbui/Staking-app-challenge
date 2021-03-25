pragma solidity >=0.6.0 <0.7.0;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Staker {
    ExampleExternalContract public exampleExternalContract;

    constructor(address exampleExternalContractAddress) public {
        exampleExternalContract = ExampleExternalContract(
            exampleExternalContractAddress
        );
    }

    mapping(address => uint256) public balances;

    uint256 public constant threshold = 1 ether;

    uint256 public deadline = now + 30 seconds;

    event Stake(address staker, uint256 amount);

    function stake() public payable {
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    function execute() public {
        require(now >= deadline, "deadline not yet reached");
        if (address(this).balance > threshold) {
            exampleExternalContract.complete{value: address(this).balance}();
        } else {
            _withdraw();
        }
    }

    function timeLeft() public view returns (uint256) {
        if (now < deadline) {
            return 0;
        } else {
            return deadline - now;
        }
    }

    function _withdraw() internal {}
}
// Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
//  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )

// After some `deadline` allow anyone to call an `execute()` function
//  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value

// if the `threshold` was not met, allow everyone to call a `withdraw()` function

// Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
// }
