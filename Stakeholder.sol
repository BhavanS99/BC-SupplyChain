// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
/* 
This contract develops a database of the parties involved
- Works in conjunction with Track smart contract 
- Call tracking contract at its deployed address

*/
contract Stakeholder {
/*
 Initialize mapping and struct to keep track of suppliers 
 Include constructor and modifier to assign admin and admin control 
*/
    address private _owner;
    string  private _name;
    mapping (address => Supplier) public suppliers;

    struct Supplier {
        address  id; // ETH address of supplier
        string name; // name of this   supplier
        uint256 upc; // what does this supplier make?
    }

    constructor(string memory name) {
        _owner = (msg.sender);
        _name = name;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    function addSupplier() public onlyOwner {
        /*
        Use the initial supplier parameters to input supplier credentials
        Check that credentials are not null and are not double entries
        */
    }

    function removeSupplier() public onlyOwner {
        //Delete supplier data - admin only
    }

    function findSupplier(address x) public view returns (Supplier memory) {
        // Return supplier details based on an address input
        // return suppliers[address]
        return suppliers[x];
    }

    function fullList() public {
    /* This is an optional feature that can be included by 
    tracking all suppliers in an array and displaying a full list when this function is called 
    */
    }

    function filterGoods() public {
    /* This function accepts a goodtype and returns all the addresses associated with that good
    You will need to loop through checking the goodtype to see if it matches the user entry and 
    temporarily store all the addresses to be returned
    */
    }
}
