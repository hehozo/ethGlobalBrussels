// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/DiamondHands.sol";

contract DiamondHandsTest is Test {
  DiamondHands public diamondHands;

  address owner = address(1);

  function setUp() public {
    diamondHands = new DiamondHands(owner);
  }

  function test_ownership() public {
    assertTrue(diamondHands.owner() == owner);

    vm.prank(owner); // need to cast ourselves as the owner for transferOwnership to
    diamondHands.transferOwnership(address(2));

    assertTrue(diamondHands.owner() == address(2));
  }

  function test_getPrice() public {
    console.log("price", diamondHands.read());
  }
}
