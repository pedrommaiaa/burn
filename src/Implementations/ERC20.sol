// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4 < 0.9.0;

import {ERC20} from "../tokens/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
