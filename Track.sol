// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
/* 
Allows parties to track shipments of goods and automatically execute payments 
once the criteria is met.

The receiving party and the shipping party will input their information, which will get verified 
by predetermined conditions. Input parameters from both parties need to match in order for transaction to 
be approved.
*/  
import "./Stakeholder.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Track is AccessControl {
    // import roles from another stakeholder contract
    address _admin;
    // add contract params from setContactParams

    struct Shipment {
        string item;
        uint quantity;
        uint[] locationData;
        uint timeStamp;
        address sender;
    }
    
/*
Initialie variables and mappings; location, lead time and payment - these will be modified by the admin for each contract
- define a structure to identify a shipment and a corresponding mapping (don't forget the tracking number for each product)
- define a mapping to track account balances

- Events need to be triggered anytime a state change is made (i.e: successful shipment, payment etc.)

// check for roles using stakeholder[address].whatever
*/
    // TODO:
    // EVENTS for fail,success, payment

    
    function sendFunds() public payable {
        /*
            Require that the amount being send is greater than the outstanding balance in the sender's account.
            if the condition is met update the balances of the sender and the reciever and trigger an event stating that the payment is complete
        */


    }

    function balance() {
        /*
            simple function that allows you to look up an adress and return the balance tied to that account
        */
        // how to check balance of token x in an eth wallet
    }


    function contractParam(){
        /* 
            This is where all the contract conditions will be set for the next leg of shipment
            - location, time, payment amount (these are initialized at the start of the contract and are modified when contract is executed)
        ***Think about other variables we can include to improve the integrity of approving shipments
        */

        // 1) Params:
        //      - cost of shipment
        //      - leadTime

        // 2) Set these params
        // 3) return done / true;
    }

    function sendShipment(){
        /*
            Use the parameters passed into the function to update the shipments mapping
            - Remember each shipment is linked via a serial or tracking number
            - Trigger an event to indicate this state change
        */    
         // 1) params:
         //     - trackingNo
         //     - what item is it (UPC)
         //     - quantity
         //     perms: manufacturer
         
         // 2) for params in shipping struct:
         //      fill out fields
         
         // 3) emit event

         // 4) return status? always true idk,


    }

    function receiveShipment(){
        /*
            Checking for the following conditions 
                - Item [Tracking Number] and Quantity match the details from the sender 
                - Once the above conditions are met, check if the location, shipping time and lead time (delay between when an order is placed and processed)
                 match and call the sendFunds function 
                - The above conditions can be applied as nested if statements and have events triggered within as each condition is met
        */
         // 1) params:
         //     - trackingNo
         //     - what item is it (UPC)
         //     - quantity
         //     
         //     perms: assembler // stakeholder in this case

         // 2) if trackingID = what we recieved as a tracking ID:
        //          && expected_quantity == what we recieved as quantity
        //    emit item recieved
        
        // 3) check if admin's critera are satisfied for a given shipment:
        //    if yes then send ETH via sendFUnds()
        //          regardless, emit status
        
        
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
