// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;   
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Roles.sol";
/*###############################################################
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

*/
contract Stakeholder is AccessControl {
    // define roles
    bytes32 public constant OWNR_ROLE = keccak256("ADMIN ROLE");
    bytes32 public constant MNFC_ROLE = keccak256("MANUFACTURER ROLE");
    bytes32 public constant ASMB_ROLE = keccak256("ASSEMBLER ROLE");
    // define the properties of the stakeholder
    address public _owner;
    string  public _name;
    uint    private _sku_count;
    mapping (uint => item)            public _products;       // SKU -> Product, mapping for completed products (pencils)
    mapping (address => bytes32)      public _parties;        // Stores ranks for involved parties
    mapping (address => manufacturer) public _manufacturers;  // List of manufacturers
    
    struct manufacturer {
        // a manufacturer is a data structure representing
        // a factory/assembler which creates a part
        address   _id;                    // ETH address of manufacturer
        string    _name;                  // name of this manufacturer
        string    _location;              // location 
        uint8     _upc;                   // what does this manufacturer make? 
    }

    struct item {
        uint     sku;                    // SKU is item ID
        uint     upc;                    // UPC is item type, ex 2 = rubber, 3 = wood
        uint     originProduceDate;      // Date item produced in factory
        string   itemName;               // English description of part
        uint     productPrice;           // Product Price
        address  manufacID;              // Ethereum address of the Distributor
    }

    constructor() {
        // Create a new Stakeholder 
        _owner = msg.sender;
        // Setup permissions for the contract
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(OWNR_ROLE, DEFAULT_ADMIN_ROLE);
        _grantRole(OWNR_ROLE, msg.sender);
    }

    // Define modifiers for role-based action control
    modifier onlyOwner() {
        require(hasRole(OWNR_ROLE, msg.sender));
        _;
    }
    modifier onlyMnfc() {
        require(hasRole(MNFC_ROLE, msg.sender));
        _;
    }
    modifier onlyAsmb() {
        require(hasRole(ASMB_ROLE, msg.sender));
        _;
    }

    function addManufacturer(
        address mfc, 
        string calldata name, 
        string calldata loc, 
        uint8 upc
        ) public onlyOwner {
        // Link manufacturer credentials using the mappings/strcuts created above
        manufacturer memory x = manufacturer(mfc, name, loc, upc);
        _manufacturers[mfc] = x;
        grantRole(MNFC_ROLE, mfc);
    }

    function deleteManufacturer(
        address x
        ) public onlyOwner {
        // Make sure only Admin address is capable of executing this
        revokeRole(MNFC_ROLE, x);
        delete _manufacturers[x];
    }

    function findManufacturer(
        address s
        ) public view returns (manufacturer memory) {
        // This function will let any user to pull out manufacturer details using their address
        return _manufacturers[s];
    }

    function getPrice(
        uint upc
        ) public view returns (uint price) {
        // Fetch the price of a product given a UPC
        return _products[upc].productPrice;
    }

    function addProduct(
        uint originProduceDate,
        uint productPrice,
        uint upc,
        string calldata name
        ) public onlyMnfc returns (bool suceess) {
        // 1) construct an Origin.Item object
        // 2) add to msg.sender's array
        // mit and mitc
        uint sku = _sku_count;
        if (_products[sku].manufacID == address(0x0) && (sku != 0)) {
            _products[sku].upc = upc;
            _products[sku].originProduceDate = originProduceDate;
            _products[sku].productPrice = productPrice;
            _products[sku].itemName = name;
            _sku_count++;
            return true;
        }
        else {
            return false;
        }

    }
    
    // TODO : 
    // implement the following functions

    /*
    function createProduct(manufacturer a, manufacturer b, manufacturer c) public Roles.onlyOwner {
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
    }
    
    
    function fullList() public {
    // https://ethereum.stackexchange.com/questions/65589/return-a-mapping-in-a-getall-function
    }

    function filterGoods(string upc) public view returns (address[] memory) {
    // This function accepts a goodtype and returns all the addresses associated with that good
    // You will need to loop through checking the goodtype to see if it matches the user entry and 
    // temporarily store all the addresses to be returned

    // https://ethereum.stackexchange.com/questions/65589/return-a-mapping-in-a-getall-function

    address[] memory filterGoods = new address[](suppliersByAddress.length);
    for (uint i = 0; i < suppliersByAddress.length; i++) {
        if (suppliers[suppliersByAddress[i]].goodsType == upc) {
            filterGoods[i] = suppliersByAddress[i];
            }
        return filterGoods;
        }
        
    }
    */
}
