// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4 < 0.9.0;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {ERC20Token} from "../implementations/ERC20.sol";

contract ERC20Test is DSTestPlus {
    ERC20Token internal token;

    function setUp() public {
        token = new ERC20Token("Token", "TKN");
    }

    function testMetadata() public {
        assertEq(token.name(), "Token");
        assertEq(token.symbol(), "TKN");
    }

    function testMint() public {
        token.mint(address(0xBEEF), 1e18);

        assertEq(token.totalSupply(), 1e18);
        assertEq(token.balanceOf(address(0xBEEF)), 1e18);
    }

    function testBurn() public {
        token.mint(address(0xBEEF), 1e18);
        
        cheats.prank(address(0xBEEF));
        token.burn(0.9e18);

        assertEq(token.totalSupply(), 1e18 - 0.9e18);
        assertEq(token.balanceOf(address(0xBEEF)), 0.1e18);
    }

    function testApprove() public {
        assertTrue(token.approve(address(0xBEEF), 1e18));

        assertEq(token.allowance(address(this), address(0xBEEF)), 1e18);
    }

    function testTransfer() public {
        token.mint(address(this), 1e18);

        assertTrue(token.transfer(address(0xBEEF), 1e18));
        assertEq(token.totalSupply(), 1e18);

        assertEq(token.balanceOf(address(this)), 0);
        assertEq(token.balanceOf(address(0xBEEF)), 1e18);
    }

    function testTransferFrom() public {
        address from = address(0xABCD);

        token.mint(address(from), 1e18);

        cheats.prank(from);
        token.approve(address(this), 1e18);

        assertTrue(token.transferFrom(address(from), address(0xBEEF), 1e18));
        assertEq(token.totalSupply(), 1e18);

        assertEq(token.allowance(address(from), address(this)), 0);

        assertEq(token.balanceOf(address(from)), 0);
        assertEq(token.balanceOf(address(0xBEEF)), 1e18);
    }

    function testInfiniteApproveTransferFrom() public {
        address from = address(0xABCD);

        token.mint(address(from), 1e18);
        
        cheats.prank(from);
        token.approve(address(this), type(uint256).max);

        assertTrue(token.transferFrom(address(from), address(0xBEEF), 1e18));
        assertEq(token.totalSupply(), 1e18);

        assertEq(token.allowance(address(from), address(this)), type(uint256).max);

        assertEq(token.balanceOf(address(from)), 0);
        assertEq(token.balanceOf(address(0xBEEF)), 1e18);
    }

    function testFailTransferInsufficientBalance() public {
        token.mint(address(this), 0.9e18);
        token.transfer(address(0xBEEF), 1e18);
    }

    function testFailTransferFromInsufficientAllowance() public {
        address from = address(0xABCD);

        token.mint(address(from), 1e18);

        cheats.prank(from);
        token.approve(address(this), 0.9e18);
        
        token.transferFrom(address(from), address(0xBEEF), 1e18);
    }

    function testFailTransferFromInsufficientBalance() public {
        address from = address(0xABCD);

        token.mint(address(from), 0.9e18);
        
        cheats.prank(from);
        token.approve(address(this), 1e18);

        token.transferFrom(address(from), address(0xBEEF), 1e18);
    }

    function testMetadata(string calldata name, string calldata symbol) public {
        ERC20Token tkn = new ERC20Token(name, symbol);
        assertEq(tkn.name(), name);
        assertEq(tkn.symbol(), symbol);
    }

    function testMint(address from, uint256 amount) public {
        cheats.assume(from != address(0));
        token.mint(from, amount);

        assertEq(token.totalSupply(), amount);
        assertEq(token.balanceOf(from), amount);
    }

    function testBurn(
        address from,
        uint256 mintAmount,
        uint256 burnAmount
    ) public {
        cheats.assume(mintAmount > burnAmount);
        cheats.assume(from != address(0));

        token.mint(from, mintAmount);

        cheats.prank(from);
        token.burn(burnAmount);

        assertEq(token.totalSupply(), mintAmount - burnAmount);
        assertEq(token.balanceOf(from), mintAmount - burnAmount);
    }

    function testApprove(address to, uint256 amount) public {
        cheats.assume(to != address(0));
        assertTrue(token.approve(to, amount));

        assertEq(token.allowance(address(this), to), amount);
    }

    function testTransfer(address from, uint256 amount) public {
        cheats.assume(from != address(0));
        token.mint(address(this), amount);

        assertTrue(token.transfer(from, amount));
        assertEq(token.totalSupply(), amount);

        if (address(this) == from) {
            assertEq(token.balanceOf(address(this)), amount);
        } else {
            assertEq(token.balanceOf(address(this)), 0);
            assertEq(token.balanceOf(from), amount);
        }
    }

    function testTransferFrom(
        address to,
        uint256 approval,
        uint256 amount
    ) public {
        cheats.assume(to != address(0));
        cheats.assume(approval > amount);

        address from = address(0xABCD);

        token.mint(address(from), amount);
        
        cheats.prank(from);
        token.approve(address(this), approval);

        assertTrue(token.transferFrom(address(from), to, amount));
        assertEq(token.totalSupply(), amount);

        uint256 app = address(from) == address(this) || approval == type(uint256).max ? approval : approval - amount;
        assertEq(token.allowance(address(from), address(this)), app);

        if (address(from) == to) {
            assertEq(token.balanceOf(address(from)), amount);
        } else {
            assertEq(token.balanceOf(address(from)), 0);
            assertEq(token.balanceOf(to), amount);
        }
    }

    function testFailBurnInsufficientBalance(
        address to,
        uint256 mintAmount,
        uint256 burnAmount
    ) public {
        cheats.assume(burnAmount > mintAmount + 1 && burnAmount < type(uint256).max);

        token.mint(to, mintAmount);

        cheats.prank(to);
        token.burn(burnAmount);
    }

    function testFailTransferInsufficientBalance(
        address to,
        uint256 mintAmount,
        uint256 sendAmount
    ) public {
        cheats.assume(sendAmount > mintAmount + 1 && sendAmount < type(uint256).max);

        token.mint(address(this), mintAmount);
        token.transfer(to, sendAmount);
    }

    function testFailTransferFromInsufficientAllowance(
        address to,
        uint256 approval,
        uint256 amount
    ) public {
        cheats.assume(amount > approval + 1 && amount < type(uint256).max);


        address from = address(0xABCD);

        token.mint(address(from), amount);

        cheats.prank(from);
        token.approve(address(this), approval);
        token.transferFrom(address(from), to, amount);
    }

    function testFailTransferFromInsufficientBalance(
        address to,
        uint256 mintAmount,
        uint256 sendAmount
    ) public {
        cheats.assume(sendAmount > mintAmount + 1 && sendAmount < type(uint256).max);

        address from = address(0xABCD);

        token.mint(address(from), mintAmount);

        cheats.prank(from);
        token.approve(address(this), sendAmount);

        token.transferFrom(address(from), to, sendAmount);
    }
}