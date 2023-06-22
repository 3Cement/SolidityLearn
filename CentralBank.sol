// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

interface IWhitelister {
    function isWhitelisted(address _wallet) external view returns (bool);
}

contract CentralBank is Ownable(msg.sender) {
    uint256 public totalBalance;

    address immutable whitelistRegistry;

    mapping(address => uint256) private balances;
    mapping(address => uint256) public lastDepositAt;

    struct DepositInfo {
        address depositor; 
        uint256 amount;
        uint256 depositedAt;
        bool takenBack;
    }

    DepositInfo [] public deposits; 

    event NewDeposit(address indexed wallet, uint256 amount);

    constructor(address whitelistRegistryAddr) {
        whitelistRegistry = whitelistRegistryAddr;
    }

    modifier whitelistedOnly() {
        require(
            IWhitelister(whitelistRegistry).isWhitelisted(msg.sender) == true,
            "caller is not whitelisted"
        );
        _;
    }

    function balanceOf(address addr) public view returns (uint256) {
        return balances[addr];
    }

    function deposit() public payable whitelistedOnly {
        require(msg.value > 0, "deposit more then zero");

        totalBalance += msg.value;
        balances[msg.sender] += msg.value;
        emit NewDeposit(msg.sender, msg.value);
        lastDepositAt[msg.sender] = block.timestamp;
        deposits.push(
            DepositInfo(msg.sender, msg.value, block.timestamp, false)
        );
    }

    function lastDepositor() public view returns(address) {
        return deposits[deposits.length - 1].depositor;
    }

    function withdraw(uint256 amount) public whitelistedOnly {
        require(balances[msg.sender] >= amount, "insufficient funds");
        require(
            block.timestamp > lastDepositAt[msg.sender] + 2 minutes,
            "withdraw not yet possible"
        );

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
        totalBalance -= amount;
        balances[msg.sender] -= amount;
    }
}
