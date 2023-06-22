// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract CentralBank is Ownable(msg.sender) {
    uint256 public totalBalance;

    mapping(address => uint256) private balances;
    mapping(address => bool) public whitelistedAddrs;
    mapping(address => uint256) public lastDepositAt;

    event NewDepostit(address indexed wallet, uint256 amount);

    modifier whitelistedOnly() {
        require(whitelistedAddrs[msg.sender] == true, "caller is not whitelisted");
        _;
    }

    function balanceOf(address addr) public view returns(uint256) {
        return balances[addr];
    }

    function whitelist(address payable addr, bool flag) public onlyOwner {
        whitelistedAddrs[addr] = flag;
    }

    function deposit() public payable whitelistedOnly {
        require(msg.value > 0, "deposit more then zero");
        
        totalBalance += msg.value;
        balances[msg.sender] += msg.value;
        emit NewDepostit(msg.sender, msg.value);
        lastDepositAt[msg.sender] = block.timestamp ;
    }

    function withdraw(uint256 amount) public whitelistedOnly {
        require(balances[msg.sender] >= amount, "insufficient funds");
        require(block.timestamp > lastDepositAt[msg.sender] + 2 minutes, "withdraw not yet possible");

        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        totalBalance -= amount;
        balances[msg.sender] -= amount;
    }
}
