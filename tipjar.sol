// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract SmartTipJar {
    address public owner;
    address[] public staffList;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function addTips() public payable {
        require(msg.value > 0);
    }

    function addStaff(address _staff) public {
        require(msg.sender == owner);
        staffList.push(_staff);
    }

    function distributeTips() public {
        require(msg.sender == owner);
        uint256 totalBalance = address(this).balance;
        require(totalBalance > 0);
        require(staffList.length > 0);

        uint256 amountPerPerson = totalBalance / staffList.length;

        for (uint256 i = 0; i < staffList.length; i++) {
            (bool success, ) = payable(staffList[i]).call{
                value: amountPerPerson
            }("");
            require(success);
        }
    }

    function viewTips() public view returns (uint256) {
        return address(this).balance;
    }
}
