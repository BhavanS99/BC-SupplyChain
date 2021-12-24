// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/* 

This contract develops a database of the parties involved
- Works in conjunction with Track smart contract 
    - Call tracking contract at its deployed address

*/

contract Stakeholder{
/*
 Initialize mapping and struct to keep track of suppliers 
 Include constructor and modifier to assign admin and admin control 
*/

    function addSupplier() {
        /*
        Use the initial supplier parameters to input supplier credentials
        Check that credentials are not null and are not double entries
        */
    }

    function removeSupplier() {
        //Delete supplier data - admin only
    }

    function findSupplier() {
        // Return supplier details based on an address input
    }

    function fullList() {
    /* This is an optional feature that can be included by 
    tracking all suppliers in an array and displaying a full list when this function is called 
    */
    }

    function filterGoods() {
    /* This function accepts a goodtype and returns all the addresses associated with that good
    You will need to loop through checking the goodtype to see if it matches the user entry and 
    temporarily store all the addresses to be returned
    */
    }

}
