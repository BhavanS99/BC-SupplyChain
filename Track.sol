// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;  
import "./Stakeholder.sol";
import "./Roles.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
/*###############################################################
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
###############################################################*/


contract Track is AccessControl {

    // Define roles
    bytes32 public constant OWNR_ROLE = keccak256("ADMIN ROLE");
    bytes32 public constant MNFC_ROLE = keccak256("MANUFACTURER ROLE");
    bytes32 public constant ASMB_ROLE = keccak256("ASSEMBLER ROLE");

    // define contract variables
    address payable public _admin;
    uint public _contractLeadTime;                     // time period from shipment to delivery for a succesful excecution, in seconds
    uint public _contractPayment;                      // payment for sucessful excecution, in ETH
    uint public _costOfShipment;                       // unit - ETH
    Stakeholder s;
    mapping(uint => Shipment) public _shipments;       // tracking No. -> shipment
    mapping(address => uint256) public _accounts;      // list of accounts 

    // define events
    event Failure(string _message, uint _timeStamp);
    event Success(string _message, uint _trackingNo, uint _timeStamp, address _sender);
    
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

    // define shipment struct
    struct Shipment {
        uint upc;
        uint quantity;
        uint[] locationData;
        uint timeStamp;
        address payable sender;
    }
    
    function fundContract() public payable {
        //The following function funds the contract - contract becomes the owner of the funds
        _accounts[msg.sender] += msg.value;
    }

    
    function sendFunds(
        address payable payee, 
        uint256 amount
        ) public payable returns (bool success) {
        //The following function transfers funds from the contract to the payee
        require(_accounts[msg.sender] >= amount, "Insufficient Funds"); 
        // move funds
        _accounts[msg.sender] -= amount;
        _accounts[payee] += amount; 
        // transfer ETH
        payee.transfer(amount);
        // emit x payed y z ETH ?
        return true;
    }

    function contractParam(
        uint leadTime, 
        uint payment
        ) public onlyOwner returns (bool success){
        // Define shipment constraints, specified by the owner     
        _contractLeadTime = leadTime;  // set acceptable lead time
        _contractPayment  = payment;   // set payment amount        
        return true;
    }

    function sendShipment(
        uint trackingNo, 
        uint upc, 
        uint quantity
        ) public payable onlyMnfc returns (bool success){
        // Function for manufacturer to send a shipment of _quanity number of _upc
        // Fill out shipment struct for a given tracking number
        _shipments[trackingNo].upc       = upc;
        _shipments[trackingNo].sender    = payable(msg.sender);
        _shipments[trackingNo].quantity  = quantity;
        _shipments[trackingNo].timeStamp = block.timestamp;
        // emit successful event
        emit Success("Items Shipped", trackingNo, block.timestamp, msg.sender);
        return true;
    }

    function receiveShipment(
        uint trackingNo, 
        uint upc, 
        uint quantity
        ) public payable onlyAsmb returns (bool success) {
        /*
            Checking for the following conditions
                - Item [Tracking Number] and Quantity match the details from the sender
                - Once the above conditions are met, check if the location, shipping time and lead time (delay between when an order is placed and processed)
                 match and call the sendFunds function
                - The above conditions can be applied as nested if statements and have events triggered within as each condition is met
        */        //checking that the item and quantity received match the item and quantity shipped
        if(_shipments[trackingNo].upc == upc && _shipments[trackingNo].quantity == quantity) {
            emit Success("Items received", trackingNo, block.timestamp, msg.sender);            //checking that the items were shipped within the set lead time
            if (block.timestamp <= _shipments[trackingNo].timeStamp + _contractLeadTime) {
                //checks have been passed, send tokens from the assmbler to the manufacturer     
                uint price = s.getPrice(upc);           
                uint transferAmt = quantity * price;
                sendFunds(_shipments[trackingNo].sender, transferAmt);
            } else {
                emit Failure("Payment not triggered as time criteria weas not met", block.timestamp);
            }
            return true;
        }
        else {
            emit Failure("Issue in item/quantity", block.timestamp);
            return false;
        }
    }

    function deleteShipment() public onlyOwner {
        // delete a shipment in extrardinary circumstances
    }

    function findShipment() public {
        /*
        Search for shipment using tracking number and return 
        details (item, quantity, location, time etc.)
        */
    }

    function balance() public view returns (uint bal) {
        //Function that allows you to look up an adress and return the balance tied to that account
    }
}
