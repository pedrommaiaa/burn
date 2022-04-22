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

    /// @notice Returns the byte from the slice at a given index.
    /// @param _slice Slice, the slice.
    /// @param index uint256, the index.
    /// @return _byte byte, The byte at that index. 
    function index(Slice memory _slice, uint256 index) internal pure returns (bytes memory _byte) {
        require(_slice.length >= index, "Index out of bounds.");

        // Returns the byte in the slice at index, _byte = slice[index]

    }
    
    /// @notice Returns the byte from the slice at a given index.
    /// @param _slice Slice, the slice.
    /// @param index int256, the index.
    /// @return _byte byte, The byte at that index. 
    function index(Slice memory _slice, int256 index) internal pure returns (bytes memory _byte) {
        if (index >= 0) return index(_slice, uint256(index));

        require(_slice.length >= index, "Index out of bounds.");

        // Returns the byte in the slice at index, _byte = slice[index]

    }
}
