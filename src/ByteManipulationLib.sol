// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// @notice Working with bytes.
library ByteManipulationLib {
    /*//////////////////////////////////////////////////////////////
                            FROM X TO BYTES
    //////////////////////////////////////////////////////////////*/

    function fromUint(uint256 x) internal pure returns (bytes memory bts) {
        bts = new bytes(32);
        assembly {
            mstore(add(bts, 32), x)
        }
    }

    /*//////////////////////////////////////////////////////////////
                            FROM BYTES TO X
    //////////////////////////////////////////////////////////////*/

    /// @notice Creates a `uint8` variable from bytes.
    /// @param _bytes bytes, the bytes.
    /// @return temp uint8, the new variable.
    function toUint8(bytes memory _bytes) internal pure returns (uint8 temp) {
        assembly {
            temp := mload(add(_bytes, 0x1))
        }
    }

    /// @notice Creates a `uint16` variable from bytes.
    /// @param _bytes bytes, the bytes.
    /// @return temp uint16, the new variable.
    function toUint16(bytes memory _bytes) internal pure returns (uint16 temp) {
        assembly {
            temp := mload(add(_bytes, 0x2))
        }
    }

    /// @notice Creates a `uint32` variable from bytes.
    /// @param _bytes bytes, the bytes.
    /// @return temp uint32, the new variable.
    function toUint32(bytes memory _bytes) internal pure returns (uint32 temp) {
        assembly {
            temp := mload(add(_bytes, 0x4))
        }
    }

    /// @notice Creates a `uint64` variable from bytes.
    /// @param _bytes bytes, the bytes.
    /// @return temp uint64, the new variable.
    function toUint64(bytes memory _bytes) internal pure returns (uint64 temp) {
        assembly {
            temp := mload(add(_bytes, 0x8))
        }
    }

    /// @notice Creates a `uint96` variable from bytes.
    /// @param _bytes bytes, the bytes.
    /// @return temp uint96, the new variable.
    function toUint96(bytes memory _bytes) internal pure returns (uint96 temp) {
        assembly {
            temp := mload(add(_bytes, 0xc))
        }
    }

    /// @notice Creates a `uint128` variable from bytes.
    /// @param _bytes bytes, the bytes.
    /// @return temp uint128, the new variable.
    function toUint128(bytes memory _bytes)
        internal
        pure
        returns (uint128 temp)
    {
        assembly {
            temp := mload(add(_bytes, 0x10))
        }
    }

    /// @notice Creates a `uint256` variable from bytes.
    /// @param _bytes bytes, the bytes.
    /// @return temp uint256, the new variable.
    function toUint256(bytes memory _bytes)
        internal
        pure
        returns (uint256 temp)
    {
        assembly {
            temp := mload(add(_bytes, 0x20))
        }
    }

    /// @notice Creates a `bytes32` variable from bytes.
    /// @param _bytes bytes, the bytes.
    /// @return temp bytes32, the new variable.
    function toBytes32(bytes memory _bytes)
        internal
        pure
        returns (bytes32 temp)
    {
        assembly {
            temp := mload(add(_bytes, 0x20))
        }
    }

    /// @notice Creates a `address` variable from bytes.
    /// @param _bytes bytes, the bytes.
    /// @return temp address, the new variable.
    function toAddress(bytes memory _bytes)
        internal
        pure
        returns (address temp)
    {
        assembly {
            temp := div(mload(add(_bytes, 0x20)), 0x1000000000000000000000000)
        }
    }
}
