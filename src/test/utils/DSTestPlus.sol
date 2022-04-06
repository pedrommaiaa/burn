// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.4;

import {DSTest} from "@ds-test/test.sol";
import {XConsole} from "./Console.sol";
import {CheatCodes} from "./CheatCodes.sol";

contract DSTestPlus is DSTest {
    XConsole console = new XConsole();

    CheatCodes internal constant cheats = CheatCodes(HEVM_ADDRESS);

}
