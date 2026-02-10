// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract tips {

    address public owner;

    struct Waitress {
        address payable walletAddress;
        string name;
        uint percent;
    }

    Waitress[] public waitress;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    function addtips() payable public {}

    function viewtips() public view returns(uint) {
        return address(this).balance;
    }

    function addWaitress(address payable _walletAddress, string memory _name, uint _percent) public onlyOwner {
        bool waitressExist = false;

        for (uint i = 0; i < waitress.length; i++) {
            if (waitress[i].walletAddress == _walletAddress) {
                waitressExist = true;
                break;
            }
        }

        if (waitressExist == false) {
            waitress.push(Waitress(_walletAddress, _name, _percent));
        }
    }

    function viewWaitress() public view returns(Waitress[] memory) {
        return waitress;
    }
}