// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {ByteManipulationLib} from "../ByteManipulationLib.sol";


contract ByteManipulationLibTest is DSTestPlus {

    using ByteManipulationLib for bytes;
    using ByteManipulationLib for ByteManipulationLib.Slice;

    function testCreateSlice() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;
        uint256 memPtr;
        
        assembly {
            memPtr := add(bts, 0x20)
        }

        ByteManipulationLib.Slice memory slice = bts.slice();

        assertEq(slice.memPtr, memPtr);
        assertEq(slice.length, bts.length);
    }


    function testSliceLength() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;
        uint256 memPtr;
        
        assembly {
            memPtr := add(bts, 0x20)
        }

        ByteManipulationLib.Slice memory slice = bts.slice();

        assertEq(bts.length, slice.length);
    }

    function testSliceCopy() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;
        uint256 memPtr;
        
        assembly {
            memPtr := add(bts, 0x20)
        }

        ByteManipulationLib.Slice memory slice = bts.slice();
        ByteManipulationLib.Slice memory slice2 = slice.copy();

        assertEq(slice.memPtr, slice2.memPtr);
        assertEq(slice.length, slice2.length);
    }


    function testSliceIsEqual() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;
        uint256 memPtr;
        
        assembly {
            memPtr := add(bts, 0x20)
        }

        ByteManipulationLib.Slice memory slice = bts.slice();
        ByteManipulationLib.Slice memory slice2 = slice.copy();

        assertTrue(slice.isEqual(slice2));

    }

}
