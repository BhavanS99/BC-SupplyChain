// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/*
This contract tracks the origin of the part and pertaining detail.
Records producer details and allows parties involved to check the provenance of goods using a serial number or tags.
*/

contract origin{
/* Variable declarataion & Modifiers/Constructors
- Need to create a mapping/struct to identify each unique product and manufacturer
- Ensure that address that is calling the contract is the admin 
    - This will become critical when connecting with multiple contracts

- Make sure you specify visibility for each function 
*/

    function addManufacturer(){
        //Link manufacturer credentials using the mappings/strcuts created above
    }

    function deleteManufacturer(){
        //Make sure only Admin address is capable of executing this
    }

    function findManufacturer() {
        //This function will let any user to pull out manufacturer details using their address
        //Essentially, finding a user in a database
    }

    /*
    The following functions are product specific and are similar to the manufacturer specific functions
    */
    function addProduct(){

    }

    function removeProduct(){

    }

    function findProduct(){


    }
}
