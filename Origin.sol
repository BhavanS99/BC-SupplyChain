// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
/*
This contract tracks the origin of the part and pertaining detail.
Records producer details and allows parties involved to check the provenance of goods using a serial number or tags.
PROVENENCE
*/

contract Origin is Ownable{
/* Variable declarataion & Modifiers/Constructors*/

  // Define enum 'State' with the following values:
    enum State {
        ProducedByFactory,   
        ForSaleByFactory,        
        PurchasedByDistributor, 
        ShippedByFarmer,      
        ReceivedByDistributor,
        BuiltByDistributor,     
        PackageByDistributor,   
        ForSaleByDistributor,   
        PurchasedByRetailer,    
        ShippedByDistributor,    
        ReceivedByRetailer,      
        ForSaleByRetailer,       
        PurchasedByConsumer     
    }

    State constant defaultState = State.ProducedByFactory;
  
  // Define the Item struct for the Pencil object:
    struct Item {
        uint     sku;                    // SKU is item ID
        uint     upc;                    // UPC is item type, ex 2 = rubber, 3 = wood
        address  ownerID;                // Ethereum address of the current owner as the product moves through 8 stages
        address  originFactoryID;        // Ethereum address of the Farmer // ADDED PAYABLE
        string   originFactoryName;      // Factory Name
        uint     originProduceDate;      // Date item produced in factory
        uint     productPrice;           // Product Price
        address  distributorID;          // Ethereum address of the Distributor
        address  retailerID;             // Ethereum address of the Retailer
        address  consumerID;             // Ethereum address of the Consumer // ADDED payable
        State    itemState;              // Product State as represented in the enum above
    }

/*
- Ensure that address that is calling the contract is the admin 
    - This will become critical when connecting with multiple contracts
- TODO: EVENTS (emit on state change, item is received/produced)
- TODO: MODIFIERS for changing product state
- TODO: deterermine visibility and payability of functions
- TODO: Setter/Getter methods 
*/

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

    function findProduct() public onlyOwner {

    }
}
