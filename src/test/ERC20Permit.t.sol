// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4 < 0.9.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {ERC20Token} from "../implementations/ERC20Permit.sol";

contract ERC20Test is DSTestPlus {
    ERC20Token internal token;

    bytes32 constant PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    function setUp() public {
        token = new ERC20Token("Token", "TKN");
    }

    function testPermit() public {

        uint256 privateKey = 0xABCD;
        address owner = cheats.addr(privateKey);

        (uint8 v, bytes32 r, bytes32 s) = cheats.sign(
            privateKey,
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    token.DOMAIN_SEPARATOR(),
                    keccak256(abi.encode(PERMIT_TYPEHASH, owner, address(0xDCBA), 1e18, 0, block.timestamp))
                )
            )
        );


        emit log_bytes32(token.permit(owner, address(0xDCBA), 1e18, block.timestamp, v, r, s));
    }

}
