// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2; 
import "@openzeppelin/contracts/access/AccessControl.sol";
/*###############################################################
###                                                           ###
###                       QMIND 2021                          ###
###               BC-SUPPLYCHAIN : ETHEREUM                   ###
###               CONTRACT       : ROLES                      ###
###                                                           ###
###   This contract stores the roles of parties involved,     ###
###   has modifiers for enforce permissoins within the        ###
###   contract                                                ###
###                                                           ###
###############################################################*/
contract Roles is AccessControl {
    // setup permissions, roles for parties involved
    bytes32 public constant OWNR_ROLE = keccak256("ADMIN ROLE");
    bytes32 public constant MNFC_ROLE = keccak256("MANUFACTURER ROLE");
    bytes32 public constant ASMB_ROLE = keccak256("ASSEMBLER ROLE");
    // modifiers for other functions in supplychain
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
}