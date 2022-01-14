// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;   
/* 
This contract develops a database of the parties involved
- Works in conjunction with Track smart contract 
- Call tracking contract at its deployed address
*/

// imports
import "./Origin.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Stakeholder is AccessControl {
/*
 Initialize mapping and struct to keep track of suppliers 
 Include constructor and modifier to assign admin and admin control
*/
    // define contract roles
    bytes32 public constant OWNR_ROLE = keccak256("ADMIN ROLE");
    bytes32 public constant MNFC_ROLE = keccak256("MANUFACTURER ROLE");

    // define the properties of the stakeholder
    address public _owner;
    string  public _name;
    mapping (address => manufacturer) public _manufacturers;  //  List of manufacturers
    mapping (address => bytes32) public _parties;    // Stores ranks for involved parties
    
    // todo:  make a struct to store the completed pencils
    
    // QMIND dev function:
    mapping (uint8 => string) public UPC_CODES;

    struct manufacturer {
        // Struct : Factory/Farm that produces parts
        address _id;                                  // ETH address of manufacturer
        string _name;                                 // name of this manufacturer
        string _location;                             // location 
        uint8 _upc;                                // what does this manufacturer make? 
        Origin.Item[] _items;
        // there no need to hold a rank like manufacturer
        // in this struct, since the contract who called the
        // constructor keeps a list
    }

    struct Item {
        uint     sku;                    // SKU is item ID
        uint     upc;                    // UPC is item type, ex 2 = rubber, 3 = wood
        uint     originProduceDate;      // Date item produced in factory
        string   itemName;
        uint     productPrice;           // Product Price
        address  manufacID;          // Ethereum address of the Distributor
    
    }

    constructor(string memory name){
        // Create a new Stakeholder 
        _owner = msg.sender;
        _name = name;
        _setupRole(OWNR_ROLE, msg.sender);
    }

    modifier onlyOwner() {
        // make function callable only by admin
        require(hasRole(OWNR_ROLE, msg.sender));
        _;
    }

    modifier onlyMnfc() {
        require(hasRole(MNFC_ROLE, msg.sender));
        _;
    }

    /**
    // we might need this extra layer of complexity at a later date...

    function addSupplier() public onlyOwner {
        //Use the initial supplier parameters to input supplier credentials
        //Check that credentials are not null and are not double entries
    }

    function removeSupplier(address x) public onlyOwner {
        //Delete supplier data - admin only
        delete manufacturers[x];
    }

    function findSupplier(address s) public view returns (manufacturer memory) {
        // Return supplier details based on an address input
        return manufacturers[s];

    }
    */

    function addManufacturer (string memory name, string memory loc, uint8 upc) public onlyOwner {
        //Link manufacturer credentials using the mappings/strcuts created above
        manufacturer memory x = manufacturer(msg.sender, name, loc, upc);
        _manufacturers[msg.sender] = x;
        grantRole(MNFC_ROLE, msg.sender);
    }

    function deleteManufacturer(address x) public onlyOwner {
        //Make sure only Admin address is capable of executing this
        revokeRole(MNFC_ROLE, x);
        delete _manufacturers[x];
    }

    function findManufacturer(address s) public view returns (manufacturer memory) {
        //This function will let any user to pull out manufacturer details using their address
        return _manufacturers[s];
    }

    /*
    The following functions are product specific and are similar to the manufacturer specific functions
    */
    function addProduct() public onlyMnfc {
        // 1) construct an Origin.Item object
        // 2) add to msg.sender's array
    }

    function fullList() public {
    /* This is an optional feature that can be included by 
    tracking all manufacturers in an array and displaying a full list when this function is called 
    */
    // https://ethereum.stackexchange.com/questions/65589/return-a-mapping-in-a-getall-function
    }

    function filterGoods() public {
    /* This function accepts a goodtype and returns all the addresses associated with that good
    You will need to loop through checking the goodtype to see if it matches the user entry and 
    temporarily store all the addresses to be returned
    */
    // https://ethereum.stackexchange.com/questions/65589/return-a-mapping-in-a-getall-function
    }



    /** Best practice security wise 
            - public function calls internal function



        /// Define a public function to transfer ownership
        function transferOwnership(address newOwner) public onlyOwner {
            _transferOwnership(newOwner);
    }

        /// Define an internal function to transfer ownership
        function _transferOwnership(address newOwner) internal {
            require(newOwner != address(0));
            emit TransferOwnership(origOwner, newOwner);
            origOwner = newOwner;
    }
}
     */

     // TODO :
     // combine into pencil functionality
     // 
}
