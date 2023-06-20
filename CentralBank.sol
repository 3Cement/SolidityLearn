// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract CentralBank {
    address private owner;
    uint256 public totalBalance;
    mapping(address => uint) public balances;

    constructor () {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "deposit more then zero");
        totalBalance += msg.value;
        balances[msg.sender] += msg.value;
    }
}
