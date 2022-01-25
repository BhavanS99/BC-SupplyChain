// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;  
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
#################################################################

PHASE 1 DEADLINE : January 27th  2022

*/

import "./Stakeholder.sol";
import "./Roles.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Track is AccessControl {
    // define contract variables
    address public _admin;
    uint public contractLeadTime;                     // time period from shipment to delivery for a succesful excecution, in seconds
    uint public contractPayment;                      // payment for sucessful excecution, in ETH
    uint public costOfShipment;                       // unit - ETH
    mapping(uint => Shipment) public shipments;       // tracking No. -> shipment
    mapping(address => uint256) public accounts;      // list of accounts ?

    // define events
    event Failure(string _message, uint _timeStamp);
    event Success(string _message, string _trackingNo, uint _timeStamp, address _sender);

    // define shipment struct
    struct Shipment {
        string item;
        uint quantity;
        uint[] locationData;
        uint timeStamp;
        address sender;
    }
    
    
    function fundContract() public payable {
        //The following function funds the contract - contract becomes the owner of the funds
        accounts[msg.sender] += msg.value;
    }

    
    
    function sendFunds(address payable payee, uint256 amount) public payable returns (bool success) {
        //The following function transfers funds from the contract to the payee
        // make sure account has sufficient funding
        require(accounts[msg.sender] >= amount, "Insufficient Funds"); 
        // move funds
        accounts[msg.sender] -= amount;
        accounts[payee] += amount; 
        // transfer ETH
        payee.transfer(amount);
        // emit x payed y z ETH ?
        return true;
    }

    function balance() public {
        //Function that allows you to look up an adress and return the balance tied to that account
        _;
    }


    function contractParam(uint leadTime, uint payment) public Roles.onlyOwner returns (bool success){
        // Define shipment constraints, specified by the owner     
        contractLeadTime = leadTime; // set acceptable lead time
        contractPayment = payment;   // set payment amount        
        return true;
    }

    function sendShipment(uint trackingNo, uint upc, uint quantity) public Roles.onlyMnfc returns (bool success){
        // Function for manufacturer to send a shipment of _quanity number of _upc
        // Fill out shipment struct for a given tracking number
        shipments[trackingNo].item = upc;
        shipments[trackingNo].quantity = quantity;
        shipments[trackingNo].timeStamp = block.timestamp;
        shipments[trackingNo].sender = msg.sender;    
        // emit successful event
        emit Success("Items Shipped", trackingNo, block.timestamp, msg.sender);
        return true;
    }

    function receiveShipment(uint trackingNo, uint upc, uint quantity) public Roles.onlyAsmb returns (bool success) {
        /*
            Checking for the following conditions
                - Item [Tracking Number] and Quantity match the details from the sender
                - Once the above conditions are met, check if the location, shipping time and lead time (delay between when an order is placed and processed)
                 match and call the sendFunds function
                - The above conditions can be applied as nested if statements and have events triggered within as each condition is met
        */        //checking that the item and quantity received match the item and quantity shipped
        if(shipments[trackingNo].item == upc && shipments[trackingNo].quantity == quantity) {
            emit Success("Items received", _trackingNo, block.timestamp, msg.sender);            //checking that the items were shipped within the set lead time
            if (block.timestamp <= shipments[trackingNo].timeStamp + contractLeadTime) {
                //checks have been passed, send tokens from the assmbler to the manufacturer                
                uint transferAmt = _quanity * Stakeholder.prices[upc];
                sendFunds(shipments[trackingNo].sender, transferAmt);
            } else {
                emit Failure("Payment not triggered as time criteria weas not met");
            }
            return true;
        }
        else {
            emit Failure("Issue in item/quantity");
            return false;
        }
    }

    function deleteShipment(uint trackingNo) public Roles.onlyAdmin {
        // delete a shipment in extrardinary circumstances
        delete shipments[trackingNo]
        // probably need some return true // try/accept checks idk
    }

    function findShipment(){
        /*
        Search for shipment using tracking number and return 
        details (item, quantity, location, time etc.)
        */
    }
}
