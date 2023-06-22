// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Whitelister is Ownable(msg.sender) {
    mapping(address => bool) public whitelistedAddrs;

    function whitelist(address payable addr, bool flag) public onlyOwner {
        whitelistedAddrs[addr] = flag;
    }

    function istWhitelisted(address _wallet) public view returns(bool) {
        return whitelistedAddrs[_wallet];
    }
}
