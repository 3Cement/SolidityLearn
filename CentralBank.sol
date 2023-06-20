// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract CentralBank {
    address private owner;
    uint256 public totalBalance;
    mapping(address => uint) private balances;
    mapping(address => bool) public whitelistedAddrs;

    constructor () {
        owner = msg.sender;
    }

    modifier whitelistedOnly() {
        require(whitelistedAddrs[msg.sender] == true, "caller is not whitelisted");
        _;
    }

    function balanceOf(address addr) public view returns(uint) {
        return balances[addr];
    }

    function whitelist(address payable addr, bool flag) public {
        require(msg.sender == owner, "caller is not an owner");
        whitelistedAddrs[addr] = flag;
    }

    function deposit() public payable whitelistedOnly {
        require(msg.value > 0, "deposit more then zero");
        totalBalance += msg.value;
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public whitelistedOnly {
        require(balances[msg.sender] >= amount, "insufficient funds");

        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        totalBalance -= amount;
        balances[msg.sender] -= amount;
    }
}
