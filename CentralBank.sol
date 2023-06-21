// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract CentralBank is Ownable(msg.sender) {
    uint256 public totalBalance;
    
    mapping(address => uint) private balances;
    mapping(address => bool) public whitelistedAddrs;

    modifier whitelistedOnly() {
        require(whitelistedAddrs[msg.sender] == true, "caller is not whitelisted");
        _;
    }

    function balanceOf(address addr) public view returns(uint) {
        return balances[addr];
    }

    function whitelist(address payable addr, bool flag) public onlyOwner {
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
