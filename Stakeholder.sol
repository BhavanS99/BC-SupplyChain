// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
/* 
This contract develops a database of the parties involved
- Works in conjunction with Track smart contract 
- Call tracking contract at its deployed address

- Recall : each line costs ETH in gas, so try to simplify

*/
contract Stakeholder {
/*
 Initialize mapping and struct to keep track of suppliers 
 Include constructor and modifier to assign admin and admin control

 The Stakeholder : owns the pencil distrbution, and can choose whether 
 or not to use the same wallet address.

 The Supplier    : assembles pencils (1 wood + 1 graphite + 1 eraser)
*/
    // define the properties of the stakeholder
    address public _owner;
    string  public _name;
    mapping (address => supplier) public suppliers;  //  List of pencil suppliers
    mapping (address => bytes32 ) public parties;    // Stores ranks for involved parties
    
    // QMIND dev function:
    mapping (uint8 => string) public UPC_CODES;

    struct supplier {
        // Struct : Company that sells compiled pencils
        address  _id;                               // ETH address of supplier
        string _name;                               // name of this supplier
        uint8 _upc;                                 // what does this supplier make?
    }

    struct manufacturer {
        // Struct : Factory/Farm that produces parts
        address _id;                                 // ETH address of manufacturer
        string _name;                                 // name of this manufacturer
        string _location;                             // location 
        uint8 _upc;                                   // what does this manufacturer make? 
        // there no need to hold a rank like manufacturer
        // in this struct, since the contract who called the
        // constructor keeps a list
    }

    constructor(string memory name) {
        // Create a new Stakeholder 
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

    function findSupplier(address s) public view returns (supplier) {
        // Return supplier details based on an address input
        // return suppliers[address]
        return suppliers[s];
    }

    function addManufacturer(string memory name, uint256 upc) public view onlyOwner {
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
