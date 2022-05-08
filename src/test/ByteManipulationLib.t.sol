// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {ByteManipulationLib} from "../ByteManipulationLib.sol";


contract ByteManipulationLibTest is DSTestPlus {

    using ByteManipulationLib for bytes;

    function testByte() public {
        assertTrue(true);
    }
}
