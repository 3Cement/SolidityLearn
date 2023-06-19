// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract CentralBank {
    address private owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint256 public totalBalance = 1000;
    mapping(address => uint) public balances;

    function increaseTotalBalance(uint amount) public {
        totalBalance = totalBalance + amount;
    }

    function createAccount(address newAcc, uint amount) public {
        require(msg.sender == owner, "sender is unauthorized");
        require(amount <= totalBalance, "amount is incorrect");

        balances[newAcc] = amount;
        totalBalance = totalBalance - amount;
    }
}
