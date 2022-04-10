// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4 < 0.9.0;

error InsufficiantBalance(address user, uint256 amount);
error ApproveSpenderZeroAddress();
error TransferFromZeroAddress();
error TransferToZeroAddress();
error InsufficientAllowance();
error BurnZeroAddress();
error MintZeroAddress();

/// @title Standard ERC20 Token
/// @notice Gas efficient & error friendly ERC20 implementation.
/// @author Pedro Maia (https://github.com/pedrommaiaa/Burn)
/// @author Modified from Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
/// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol)
/// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
abstract contract ERC20 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                            METADATA STORAGE
    //////////////////////////////////////////////////////////////*/

    string public name;

    string public symbol;

    uint8 public constant decimals = 18;

    /*//////////////////////////////////////////////////////////////
                              ERC20 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    /*//////////////////////////////////////////////////////////////
                            EIP-2612 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 internal immutable INITIAL_CHAIN_ID;

    bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;

    mapping(address => uint256) public nonces;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @dev Sets the values for {name} and {symbol}.
    /// 
    /// The default value of {decimals} is 18. To select a different value for
    /// {decimals} you should overload it.
    /// 
    /// All two of these values are immutable: they can only be set once during
    /// construction.
    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;

        INITIAL_CHAIN_ID = block.chainid;
        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
    }

    /*//////////////////////////////////////////////////////////////
                               ERC20 LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    ///      Beware that changing an allowance with this method brings the risk that someone may use both the old
    ///      and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    ///      race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    ///      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    /// @param spender address, the address which will spend the funds.
    /// @param amount uint256, the amount of tokens to be spent. 
    function approve(address spender, uint256 amount) public virtual returns (bool) {
        if (spender == address(0)) revert ApproveSpenderZeroAddress();
        
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    /// @dev Transfer token for a specified address
    /// @param to address, the address to transfer to.
    /// @param amount uint256, the amount to be transferred.
    function transfer(address to, uint256 amount) public virtual returns (bool) {
        if (to == address(0)) revert TransferToZeroAddress();

        uint256 toBalance = balanceOf[msg.sender];
        if (toBalance < amount) revert InsufficiantBalance(msg.sender, amount);

        // Cannot {over/under}flow because `msg.sender` 
        // balance was already checked and the sum of 
        // all user balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[msg.sender] = toBalance - amount;
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    /// @dev Transfer tokens from `from` address to `to` address.
    /// @param from address, the address which you want to send tokens from
    /// @param to address, the address which you want to transfer to
    /// @param amount uint256, the amount of tokens to be transferred
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        if (from == address(0)) revert TransferFromZeroAddress();
        if (to == address(0)) revert TransferToZeroAddress();

        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed < amount) revert InsufficientAllowance();

        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

        uint256 fromBalance = balanceOf[from];
        if (fromBalance < amount) revert InsufficiantBalance(from, amount);

        // Cannot {over/under}flow because `msg.sender` 
        // balance was already checked and the sum of 
        // all user balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[from] = fromBalance - amount;   
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    /*//////////////////////////////////////////////////////////////
                             EIP-2612 LOGIC
    //////////////////////////////////////////////////////////////*/

    function computeDomainSeparator() internal view virtual returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                    keccak256(bytes(name)),
                    keccak256("1"),
                    block.chainid,
                    address(this)
                )
            );
    }


    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    /// @dev Internal function that mints an amount of the token and assigns it to
    ///      `to` address.
    /// @param to address, the account that will receive the created tokens.
    /// @param amount uint256, the amount that will be created.
    function _mint(address to, uint256 amount) internal virtual {
        if (to == address(0)) revert MintZeroAddress();
        
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    /// @dev Internal function that burns an amount of the token of a given
    ///      account.
    /// @param from address, the account whose tokens will be burnt.
    /// @param amount uint256, the amount that will be burnt.
    function _burn(address from, uint256 amount) internal virtual {
        if (from == address(0)) revert BurnZeroAddress();

        uint256 fromBalance = balanceOf[from];
        if (fromBalance < amount) revert InsufficiantBalance(from, amount);

        // Cannot underflow because `from` balance was
        // already checked and the user's balance
        // will never be larger than the total supply.
        unchecked {
            balanceOf[from] = fromBalance - amount;
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}
