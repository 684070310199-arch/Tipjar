// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract tips {
    address owner; 

    struct Waitress {
        address payable walletAddress;
        string name;
        uint percent;
    }

    Waitress[] waitress; 

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    // ฟังก์ชันช่วยคำนวณเปอร์เซ็นต์รวมปัจจุบัน
    function getTotalPercent() public view returns(uint) {
        uint total = 0;
        for(uint i = 0; i < waitress.length; i++) {
            total += waitress[i].percent;
        }
        return total;
    }

    // 1. เพิ่มรายชื่อพนักงาน (เพิ่มการเช็คเปอร์เซ็นต์เกิน 100)
    function addWaitress(address payable _walletAddress, string memory _name, uint _percent) public onlyOwner {
        // เช็คว่ามี Address ซ้ำหรือไม่
        for(uint i = 0; i < waitress.length; i++) {
            require(waitress[i].walletAddress != _walletAddress, "Waitress already exists");
        }

        // เช็คว่าถ้าเพิ่มคนนี้แล้ว เปอร์เซ็นต์รวมจะเกิน 100 หรือไม่
        uint currentTotal = getTotalPercent();
        require(currentTotal + _percent <= 100, "Total percent exceeds 100%");

        waitress.push(Waitress(_walletAddress, _name, _percent));
    }

    // 2. ปุ่มโอนเงิน
    function distributeBalance() public payable onlyOwner {
        require(msg.value > 0, "Please put money in VALUE field");
        require(waitress.length > 0, "No waitress in list");
        
        // เช็คเพื่อความชัวร์ว่าคนในลิสต์รวมกันต้องไม่เกิน 100%
        require(getTotalPercent() <= 100, "Setup error: Total percent in list exceeds 100%");

        uint totalSent = msg.value; 

        for(uint j = 0; j < waitress.length; j++){
            uint distributeAmount = (totalSent * waitress[j].percent) / 100;
            if (distributeAmount > 0) {
                (bool success, ) = waitress[j].walletAddress.call{value: distributeAmount}("");
                require(success, "Transfer failed");
            }
        }
    }

    function viewWaitress() public view returns(Waitress[] memory) {
        return waitress;
    }

    function viewtips() public view returns(uint) {
        return address(this).balance;
    }

    function removeWaitress(address _walletAddress) public onlyOwner {
        for(uint i=0; i<waitress.length; i++){
            if(waitress[i].walletAddress == _walletAddress){
                waitress[i] = waitress[waitress.length - 1];
                waitress.pop();
                break;
            }
        }
    }

    function addtips() payable public {}
}