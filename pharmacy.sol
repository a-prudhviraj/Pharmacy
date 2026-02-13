// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Pharmacy {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    struct Medicine {
        string name;
        uint256 price;
        uint256 stock;
    }

    mapping(uint256 => Medicine) public medicines;
    uint256 public medicineCount;

    event MedicinePurchased(uint256 id, address buyer);

    function addMedicine(
        string memory _name,
        uint256 _price,
        uint256 _stock
    ) public onlyOwner {

        medicineCount++;

        medicines[medicineCount] = Medicine(
            _name,
            _price,
            _stock
        );
    }

    function buyMedicine(uint256 _id) public payable {

        Medicine storage med = medicines[_id];

        require(med.stock > 0, "Out of stock");
        require(msg.value >= med.price, "Insufficient payment");

        med.stock--;

        emit MedicinePurchased(_id, msg.sender);
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
