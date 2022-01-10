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

 The Stakeholder : owns the pencil distrbution, and can choose whether 
 or not to use the same wallet address.

 The Supplier   : assembles pencils (1 wood + 1 graphite + 1 eraser)
*/
    // define the properties of the stakeholder

    address public _owner;
    string  public _name;
    mapping (address => Supplier) public suppliers;

    struct Supplier {
        // Supplier : struct 
        //          : This is the user who sells compiled pencils

        // Define a supplier 
        address  id; // ETH address of supplier
        string name; // name of this supplier
        uint256 upc; // what does this supplier make?
        // theres probably many more fields we will need...
    }

    struct Manufacturer {
        address  id; // ETH address of supplier
        string name; // name of this supplier
        uint256 upc; // what does this supplier make? 
        // role manufacturer
        // theres probably many more fields we will need...
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

    function addManufacturer() public onlyOwner {
        //Link manufacturer credentials using the mappings/strcuts created above
    }

    function deleteManufacturer() public onlyOwner {
        //Make sure only Admin address is capable of executing this
    }

    function findManufacturer() public onlyOwner {
        //This function will let any user to pull out manufacturer details using their address
        //Essentially, finding a user in a database
    }

    /*
    The following functions are product specific and are similar to the manufacturer specific functions
    */
    function addProduct() public onlyOwner {

    }

    function removeProduct() public onlyOwner {

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
