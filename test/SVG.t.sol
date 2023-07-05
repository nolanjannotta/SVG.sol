// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SVGConsumer.sol";

contract SVGTest is Test {
    SVGConsumer public consumer;

    function setUp() public {
        consumer = new SVGConsumer();
        
    }

    function testRandomDots() public {
        string memory svg = consumer.randomDots(768769896, 900);
        vm.writeLine("random_dots.svg", svg);
    }


    function testArt() public {
        string memory svg = consumer.art(1,9875);
        vm.writeLine("art.svg", svg);
    }


}
