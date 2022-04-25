// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {ByteManipulationLib} from "../ByteManipulationLib.sol";


contract ByteManipulationLibTest is DSTestPlus {

    using ByteManipulationLib for bytes;
    using ByteManipulationLib for ByteManipulationLib.Slice;

    function testCreateSliceFromBytes() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;
        uint256 memPtr;
        
        assembly {
            memPtr := add(bts, 0x20)
        }

        ByteManipulationLib.Slice memory slice = bts.sliceFromBytes();

        assertEq(slice.memPtr, memPtr);
        assertEq(slice.length, bts.length);
    }
    
    function testCreateSliceFromBytesAtIndex() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;
        uint256 memPtr;
        uint256 index = 1;
        
        assembly {
            memPtr := add(add(bts, 0x20), index)
        }

        ByteManipulationLib.Slice memory slice = bts.sliceFromBytes(index);

        assertEq(slice.length, bts.length - 1);
        assertEq(slice.memPtr, memPtr);
    }

    function testCreateSliceFromBytesAtIndexSigned() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;
        uint256 memPtr;
        uint256 length = bts.length;
        
        int256 index = -2;
        
        assembly {
            memPtr := add(add(bts, 0x20), add(length, index))
        }

        ByteManipulationLib.Slice memory slice = bts.sliceFromBytes(index);

        assertEq(slice.length, length - 1);
        assertEq(slice.memPtr, memPtr);
    }




    function testSliceLength() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;

        ByteManipulationLib.Slice memory slice = bts.sliceFromBytes();

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

        ByteManipulationLib.Slice memory slice = bts.sliceFromBytes();
        ByteManipulationLib.Slice memory slice2 = slice.copy();

        assertEq(slice.memPtr, slice2.memPtr);
        assertEq(slice.length, slice2.length);
    }

    function testSliceIsEqual() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;

        ByteManipulationLib.Slice memory slice = bts.sliceFromBytes();
        ByteManipulationLib.Slice memory slice2 = slice.copy();

        assertTrue(slice.isEqual(slice2));

    }

    function testSliceIndex() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;

        ByteManipulationLib.Slice memory slice = bts.sliceFromBytes();

        assertEq(slice.index(uint256(0)).toUint8(), 0x07);
        assertEq(slice.index(uint256(1)).toUint8(), 0x08);
        assertEq(slice.index(uint256(2)).toUint8(), 0x09);
    }
    
    function testSliceIndexSigned() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;

        ByteManipulationLib.Slice memory slice = bts.sliceFromBytes();

        assertEq(slice.index(-3).toUint8(), 0x07);
        assertEq(slice.index(-2).toUint8(), 0x08);
        assertEq(slice.index(-1).toUint8(), 0x09);
    }
    
    function testSliceSetIndex() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;

        ByteManipulationLib.Slice memory slice = bts.sliceFromBytes();

        slice.set(uint256(0), 0x01);

        assertEq(slice.index(uint256(0)).toUint8(), 0x01);
    }
    
    function testSliceSetIndexSigned() public {
        bytes memory bts = new bytes(3);
        bts[0] = 0x07;
        bts[1] = 0x08;
        bts[2] = 0x09;

        ByteManipulationLib.Slice memory slice = bts.sliceFromBytes();

        slice.set(-3, 0x01);

        assertEq(slice.index(-3).toUint8(), 0x01);
    }
}
