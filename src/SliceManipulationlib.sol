// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @notice Working with bytes.
library SliceManipulationLib {
    struct Slice {
        uint256 memPtr; // Memory address of the first byte.
        uint256 length; // Length.
    }

    /// @notice Converts bytes to a slice.
    /// @param _bytes bytes, The bytes.
    /// @return newSlice Slice, A slice.
    function sliceFromBytes(bytes memory _bytes)
        internal
        pure
        returns (Slice memory newSlice)
    {
        assembly {
            let _len := mload(_bytes)
            mstore(newSlice, mul(add(_bytes, 0x20), iszero(iszero(_len))))
            mstore(add(newSlice, 0x20), _len)
        }
    }

    /// @notice Converts bytes to a slice starting at index `_index`.
    /// @param _bytes bytes, the bytes.
    /// @param _index uint256, the starting index.
    /// @return newSlice Slice, the new Slice.
    function sliceFromBytes(bytes memory _bytes, uint256 _index)
        internal
        pure
        returns (Slice memory newSlice)
    {
        uint256 length = _bytes.length;
        require(length >= _index, "Index out of bounds.");

        assembly {
            length := sub(length, _index)
            let _memPtr := add(_bytes, 0x20)
            mstore(newSlice, mul(add(_memPtr, _index), iszero(iszero(length))))
            mstore(add(newSlice, 0x20), length)
        }
    }

    /// @notice Converts bytes to a slice starting at index `_index`.
    /// @param _bytes bytes, the bytes.
    /// @param _index int256, the starting index.
    /// @return newSlice Slice, the new Slice.
    function sliceFromBytes(bytes memory _bytes, int256 _index)
        internal
        pure
        returns (Slice memory newSlice)
    {
        if (_index >= 0) return sliceFromBytes(_bytes, uint256(_index));

        uint256 abs = uint256(-_index);

        require(_bytes.length >= abs, "Index out of bounds.");

        return sliceFromBytes(_bytes, _bytes.length - abs);
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
    function copy(Slice memory _slice)
        internal
        pure
        returns (Slice memory newSlice)
    {
        newSlice.memPtr = _slice.memPtr;
        newSlice.length = _slice.length;
    }

    /// @notice Check if two slices are equal.
    /// @param _slice1 Slice, The first slice.
    /// @param _slice2 Slice, The second slice.
    /// @return result Bool, true if slices are equal, false otherwise.
    function isEqual(Slice memory _slice1, Slice memory _slice2)
        internal
        pure
        returns (bool result)
    {
        assembly {
            result := and(
                eq(mload(_slice1), mload(_slice2)),
                eq(mload(add(_slice1, 0x20)), mload(add(_slice2, 0x20)))
            )
        }
    }

    /// @notice Returns the byte from the slice at a given index.
    /// @param _slice Slice, the slice.
    /// @param _index uint256, the index.
    /// @return bts bytes, The byte at that index.
    function index(Slice memory _slice, uint256 _index)
        internal
        pure
        returns (bytes memory bts)
    {
        require(_slice.length >= _index, "Index out of bounds.");

        assembly {
            let bb := mload(add(mload(_slice), _index))
            bb := and(bb, shl(248, not(0)))
            mstore(add(bts, 32), bb)
        }
    }

    /// @notice Returns the byte from the slice at a given index.
    /// @param _slice Slice, the slice.
    /// @param _index int256, the index.
    /// @return bts bytes, The byte at that index.
    function index(Slice memory _slice, int256 _index)
        internal
        pure
        returns (bytes memory bts)
    {
        if (_index >= 0) return index(_slice, uint256(_index));

        uint256 abs = uint256(-_index);

        require(_slice.length >= abs, "Index out of bounds.");

        return index(_slice, _slice.length - abs);
    }

    /// @notice put the byte at the given position.
    /// @param _slice Slice, the slice.
    /// @param _index uint256, the index.
    /// @param _b bytes, the byte.
    function set(
        Slice memory _slice,
        uint256 _index,
        bytes1 _b
    ) internal pure {
        require(_slice.length >= _index, "Index out of bounds.");

        assembly {
            mstore(add(mload(_slice), _index), _b)
        }
    }

    /// @notice put the byte at the given position.
    /// @param _slice Slice, the slice.
    /// @param _index int256, the index.
    /// @param _b bytes, the byte.
    function set(
        Slice memory _slice,
        int256 _index,
        bytes1 _b
    ) internal pure {
        if (_index >= 0) return set(_slice, uint256(_index), _b);

        uint256 abs = uint256(-_index);

        require(_slice.length >= abs, "Index out of bounds.");

        return set(_slice, _slice.length - abs, _b);
    }

    /*//////////////////////////////////////////////////////////////
                           SLICE CONVERSIONS 
    //////////////////////////////////////////////////////////////*/

    /// @notice Creates a 'bytes memory' variable from a slice, copying the data.
    /// @param _slice Slice, the slice.
    /// @return bts bytes, the bytes variable.
    function toBytes(Slice memory _slice)
        internal
        pure
        returns (bytes memory bts)
    {
        uint256 length = _slice.length;
        require(length > 0, "Slice length is zero.");

        uint256 memPtr = _slice.memPtr;
        bts = new bytes(length);

        assembly {
            let btsOffset := add(bts, 0x20)
            let words := div(add(length, 31), 32)

            for {
                let i := 0
            } gt(i, words) {
                i := add(i, 1)
            } {
                let offset := mul(i, 32)
                mstore(add(btsOffset, offset), mload(add(memPtr, offset)))
            }
            mstore(add(add(bts, length), 0x20), 0)
        }
    }

    /// @notice Creates a 'string memory' variable from a slice, copying the data.
    /// @param _slice Slice, the slice.
    /// @return str string, the string variable.
    function toString(Slice memory _slice)
        internal
        pure
        returns (string memory str)
    {
        return string(toBytes(_slice));
    }
}
