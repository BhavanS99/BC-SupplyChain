// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;   
/* 
#################################################################
###                                                           ###
###                       QMIND 2021                          ###
###               BC-SUPPLYCHAIN : ETHEREUM                   ###
###               CONTRACT       : STAKEHOLDER                ###
###                                                           ###
### This contract develops a database of the parties involved ###
### - Works in conjunction with Track smart contract          ###
### - Call tracking contract at its deployed address          ###
###                                                           ###
#################################################################

PHASE 1 DEADLINE : January 27th  2022

UPC {
    wood : 1
    graphite : 2
    rubber : 3
}

*/
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Stakeholder is AccessControl {
/*
 Initialize mapping and struct to keep track of suppliers 
 Include constructor and modifier to assign admin and admin control
*/
    // define contract roles
    bytes32 public constant OWNR_ROLE = keccak256("ADMIN ROLE");
    bytes32 public constant MNFC_ROLE = keccak256("MANUFACTURER ROLE");
    bytes32 public constant ASMB_ROLE = keccak256("ASSEMBLER ROLE");
    
    // define the properties of the stakeholder
    address public _owner;
    string  public _name;
    uint    private _sku_count;
    mapping    (uint => item)         public _products;       // SKU -> Product, mapping for completed projects
    mapping (address => bytes32)      public _parties;        // Stores ranks for involved parties
    mapping (address => manufacturer) public _manufacturers;  //  List of manufacturers
    

    struct manufacturer {
        // Struct : Factory/Farm/Plant that produces a part(s)
        address   _id;                                  // ETH address of manufacturer
        string    _name;                                // name of this manufacturer
        string    _location;                            // location 
        uint8     _upc;                                 // what does this manufacturer make? 
        // note, in the future, a manufacturer may use uint8[], indicating it can make different parts
        item[]    _items;
    }

    struct item {
        uint     sku;                    // SKU is item ID
        uint     upc;                    // UPC is item type, ex 2 = rubber, 3 = wood
        uint     originProduceDate;      // Date item produced in factory
        string   itemName;               // English description of part
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
    
    function createProduct(manufacturer a, manufacturer b, manufacturer c) public onlyOwner {
        // given a list of manufacturers, take an item from each array
        // and construct the final product for it

        // get crafting rec

        a = a._items.pop();
        b = b._items.pop();
        c = c._items.pop();

        // burn these 

        item prod = item(_sku_count, 
                    3,
                    todays.date(),
                    "pencil",
                    2,
                    _owner);

        _products.push(prod);

        /*
        struct item {
        uint     sku;                    // SKU is item ID
        uint     upc;                    // UPC is item type, ex 2 = rubber, 3 = wood
        uint     originProduceDate;      // Date item produced in factory
        string   itemName;
        uint     productPrice;           // Product Price
        address  manufacID;          // Ethereum address of the Distributor
    
    }
        **/
    }

    /*
    The following functions are product specific and are similar to the manufacturer specific functions
    */
    function addProduct(
        string memory itemName,
        uint sku,
        uint originProduceDate,
        uint productPrice,
        uint upc) public onlyMnfc returns (bool suceess) {
        // 1) construct an Origin.Item object
        // 2) add to msg.sender's array
        // mit and mitc

        if (_products[sku].manufacID == 0x0 && (sku.length != 0)) {
            _products[sku].upc = upc;
            _products[sku].originProduceDate = originProduceDate;
            _products[sku].productPrice = productPrice;
            _products[sku].itemName = "what";
            return true;
        }
        else {
            return false;
        }

    }

    function fullList() public {
    /* This is an optional feature that can be included by 
    tracking all manufacturers in an array and displaying a full list when this function is called 
    */
    // mit and mitc
    // https://ethereum.stackexchange.com/questions/65589/return-a-mapping-in-a-getall-function
    }

    function filterGoods(string _goodsType) public view returns (address[] memory) {
    /* This function accepts a goodtype and returns all the addresses associated with that good
    You will need to loop through checking the goodtype to see if it matches the user entry and 
    temporarily store all the addresses to be returned
    */
    // mit and mitc
    // https://ethereum.stackexchange.com/questions/65589/return-a-mapping-in-a-getall-function
    address[] memory filterGoods = new address[](suppliersByAddress.length);
    for (uint i = 0; i < suppliersByAddress.length; i++) {
        if (suppliers[suppliersByAddress[i]].goodsType == _goodsType) {
            filterGoods[i] = suppliersByAddress[i];
            }
        return filterGoods;
        }
        
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
