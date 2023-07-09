// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SVGExample.sol";

import "../src/DateTime.sol";

contract SVGTest is Test {
    SVGExample public svgExample;

    function setUp() public {
        svgExample = new SVGExample();
    }

    function testRandomDots() public {
        string memory svg = svgExample.randomDots(768769896, 900);
        vm.writeLine("random_dots.svg", svg);
    }

    function testArt() public {
        string memory svg = svgExample.art(3, 746);
        vm.writeLine("art.svg", svg);
    }

    function testClock() public {
        vm.warp(1688877108); // timestamp of 2023 july 8 6:08 pm
        // we pass a -7 for west coast time
        string memory svg = svgExample.clock(-7);
        vm.writeLine("clock.svg", svg);
    }

    function testDateTime() public {
        vm.warp(1688875650); // timestamp of 2023 july 8 6:08 pm

        uint256 timestamp = uint256(int256(block.timestamp) + (-7 hours));

        uint256 hour = DateTime.getHour(timestamp);
        uint256 minute = DateTime.getMinute(timestamp);
        uint256 second = DateTime.getHour(timestamp);

        // (year, month, day, hour, minute, second) = DateTime.timestampToDateTime(timestamp);
        hour = hour <= 12 ? hour : hour - 12;

        // console.log("year: %s", year);
        // console.log("month: %s", month);
        // console.log("day: %s", day);
        console.log("hour: %s", hour);
        console.log("minute: %s", minute);
        console.log("second: %s", second);
        // console.log("dat of week: %s", dayOfWeek);
    }
}
