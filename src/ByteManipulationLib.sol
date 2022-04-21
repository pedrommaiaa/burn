// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @notice Working with bytes.
library ByteManipulationLib {

    struct Slice {
        uint256 memPtr; // Memory address of the first byte.
        uint256 length; // Length.
    }

    /// @notice Converts bytes to a slice.
    /// @param _bytes bytes, The bytes.
    /// @return newSlice Slice, A slice.
    function slice(bytes memory _bytes) internal pure returns (Slice memory newSlice) {
        assembly {
            let _len := mload(_bytes)
            let _memPtr := add(_bytes, 0x20)
            mstore(newSlice, mul(_memPtr, iszero(iszero(_len))))
            mstore(add(newSlice, 0x20), _len)
        }
    }

    /// @notice Get the length of the slice (in bytes).
    /// @param _slice Slice, The slice.
    /// return the length.
    function len(Slice memory _slice) internal pure returns (uint256) {
        return _slice.length;
    }

    /// @notice Creates a copy of the slice.
    /// @param _slice Slice, The slice.
    /// @return newSlice Slice, the copy.
    function copy(Slice memory _slice) internal pure returns (Slice memory newSlice) {
        newSlice.memPtr = _slice.memPtr;
        newSlice.length = _slice.length;
    }

    /// @notice Check if two slices are equal.
    /// @param _slice1 Slice, The first slice.
    /// @param _slice2 Slice, The second slice.
    /// @return result Bool, true if slices are equal, false otherwise.
    function isEqual(Slice memory _slice1, Slice memory _slice2) internal pure returns (bool result) {
        assembly {
            result := and(
                eq(mload(_slice1), mload(_slice2)),
                eq(mload(add(_slice1, 0x20)), mload(add(_slice2, 0x20)))
            )
        }
    }
}
