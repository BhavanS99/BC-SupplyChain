// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;  
/* 
Allows parties to track shipments of goods and automatically execute payments 
once the criteria is met.

The receiving party and the shipping party will input their information, which will get verified 
by predetermined conditions. Input parameters from both parties need to match in order for transaction to 
be approved.

/* 
#################################################################
###                                                           ###
###                       QMIND 2021                          ###
###               BC-SUPPLYCHAIN : ETHEREUM                   ###
###               CONTRACT       : TRACK                      ###
###                                                           ###
###   Track shipments of goods and automatically execute      ###
###   payments if contract criteria is satisfied.             ###
###                                                           ###
###   The receiving party and the shipping party will input   ###
###   their impformation which should match the expected      ###
###   fields. A matching set of details confirms              ###
###   the transaction.                                        ###
###                                                           ###
#################################################################

PHASE 1 DEADLINE : January 27th  2022

UPC {
    wood : 1
    graphite : 2
    rubber : 3
}

*/


*/  
import "./Stakeholder.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Track is AccessControl {

    bytes32 public constant OWNR_ROLE = keccak256("ADMIN ROLE");
    bytes32 public constant MNFC_ROLE = keccak256("MANUFACTURER ROLE");
    bytes32 public constant ASMB_ROLE = keccak256("ASSEMBLER ROLE");

    // define contract variables
    address public _admin;
    uint public contractLeadTime;                     // time period from shipment to delivery for a succesful excecution, in seconds
    uint public contractPayment;                      // payment for sucessful excecution, in ETH
    uint leadTime;                                    // unit - seconds 
    uint costOfShipment;                              // unit - ETH
    mapping(string => Shipment) public shipments;     // not sure about this data structure
    mapping(address => uint256) public accounts;      // list of accounts ?

    // define events
    event Success(string _message, string _trackingNo, uint _timeStamp, address _sender);
    event Failure(string _message);


    modifier onlyOwner() {
        // make function callable only by admin
        require(hasRole(OWNR_ROLE, msg.sender));
        _;
    }

    modifier onlyMnfc() {
        // make function callable only by manufacturer
        require(hasRole(MNFC_ROLE, msg.sender));
        _;
    }

    struct Shipment {
        string item;
        uint quantity;
        uint[] locationData;
        uint timeStamp;
        address sender;
    }
    
/*


- Events need to be triggered anytime a state change is made (i.e: successful shipment, payment etc.)

// check for roles using stakeholder[address].whatever
*/
    // TODO:
    // EVENTS for fail,success, payment

    //The following function funds the contract - contract becomes the owner of the funds
    
    function fundContract() public payable {
        accounts[msg.sender] += msg.value;
    }

    //The following function transfers funds from the contract to the payee
    
    function sendFunds(address payable _payee, uint256 _amount) public payable returns (bool success) {
        require(accounts[msg.sender] >= _amount,"Insufficient Funds"); 
        accounts[msg.sender] -= _amount;
        accounts[_payee] += _amount; 
        _payee.transfer(_amount);
        return true;
    }

    function balance() public {
        /*
            simple function that allows you to look up an adress and return the balance tied to that account
        */
        // how to check balance of token x in an eth wallet
    }


    function contractParam(uint _leadTime, uint _payment) public onlyOwner returns (bool success){
        /*
            This is where all the contract conditions will be set for the next leg of shipment
            - location, time, payment amount (these are initialized at the start of the contract and are modified when contract is executed)
        ***Think about other variables we can include to improve the integrity of approving shipments
        */        
        
        contractLeadTime = _leadTime; // set acceptable lead time
        contractPayment = _payment; // set payment amount        
        return true;
    }

    function sendShipment(string _trackingNo, uint _upc, uint _quantity) public onlyMnfc returns (bool success){
        /*
            Use the parameters passed into the function to update the shipments mapping
            - Remember each shipment is linked via a serial or tracking number
            - Trigger an event to indicate this state change
        */         
        shipments[_trackingNo].item = _upc;
        shipments[_trackingNo].quantity = _quantity;
        shipments[_trackingNo].timeStamp = block.timestamp;
        shipments[_trackingNo].sender = msg.sender;         
        emit Success("Items Shipped", _trackingNo, block.timestamp, msg.sender);         
        return true;
    }

    function receiveShipment(string _trackingNo, uint _upc, uint _quantity) public onlyAsmb returns (bool success) {
        /*
            Checking for the following conditions
                - Item [Tracking Number] and Quantity match the details from the sender
                - Once the above conditions are met, check if the location, shipping time and lead time (delay between when an order is placed and processed)
                 match and call the sendFunds function
                - The above conditions can be applied as nested if statements and have events triggered within as each condition is met
        */        //checking that the item and quantity received match the item and quantity shipped
        if(shipments[_trackingNo].item == _upc && shipments[_trackingNo].quantity == _quantity) {
            emit Success("Items received", _trackingNo, block.timestamp, msg.sender);            //checking that the items were shipped within the set lead time
            if (block.timestamp <= shipments[_trackingNo].timeStamp + contractLeadTime) {
                //checks have been passed, send tokens from the assmbler to the manufacturer                
                //sendToken(admin, shipments[_trackingNo].sender, contractPayment);                //Trigger Payment event
            }
            else {
                emit Failure("Payment not triggered as time criteria weas not met");
            }
            return true;
        }
        else {
            emit Failure("Issue in item/quantity");
            return false;
        }
    }

    function deleteShipment(){
        // Admin only access
    }

    function findShipment(){
        /*
        Search for shipment using tracking number and return 
        details (item, quantity, location, time etc.)
        */
    }
}
