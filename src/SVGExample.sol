pragma solidity ^0.8.13;

import {Element, createElement, utils} from "./SVG.sol";
import "./DateTime.sol";

contract SVGExample {
    function randomDots(uint256 seed, uint256 dots) public pure returns (string memory) {
        Element memory svg = createElement("svg");
        svg.setAttribute("xmlns", "http://www.w3.org/2000/svg");
        svg.setAttribute("width", "2000");
        svg.setAttribute("height", "1000");

        Element memory rect = createElement("rect");
        rect.setAttribute("width", "2000");
        rect.setAttribute("height", "1000");
        rect.setAttribute("stroke", "black");
        rect.setAttribute("stroke-width", "4px");
        rect.setAttribute("fill", "white");
        svg.appendChild(rect);

        for (uint256 i = 0; i < dots; i++) {
            uint256 _hash = uint256(keccak256(abi.encode(seed + i)));

            uint256 cy = uint256(keccak256(abi.encode(_hash + 1))) % 1000;
            uint256 cx = uint256(keccak256(abi.encode(_hash + 2))) % 2000;
            uint256 r = (uint256(keccak256(abi.encode(_hash + 3))) % 25) + 5;

            uint256 _r = uint256(keccak256(abi.encode(_hash + 4))) % 255;
            uint256 _g = uint256(keccak256(abi.encode(_hash + 5))) % 255;
            uint256 _b = uint256(keccak256(abi.encode(_hash + 6))) % 255;
            uint256 _a = (uint256(keccak256(abi.encode(_hash + 7))) % 5) + 5;
            string memory fill = utils.rgb(_r, _g, _b);
            if (_hash % 100 < 5) {
                Element memory rect = createElement("rect");
                rect.setAttribute("x", utils._toString(cx));
                rect.setAttribute("y", utils._toString(cy));
                rect.setAttribute("width", utils._toString(r));
                rect.setAttribute("height", utils._toString(r));
                rect.setAttribute("fill", fill);
                rect.setAttribute("z-index", "1000");
                svg.appendChild(rect);
            } else {
                Element memory circle = createElement("circle");
                circle.setAttribute("cx", utils._toString(cx));
                circle.setAttribute("cy", utils._toString(cy));
                circle.setAttribute("r", utils._toString(r));
                circle.setAttribute("fill", fill);
                svg.appendChild(circle);
            }
        }

        return svg.draw();
    }

    function art(uint256 transformSeed, uint256 seed) public returns (string memory) {
        Element memory svg = createElement("svg");
        svg.setAttribute("xmlns", "http://www.w3.org/2000/svg");
        svg.setAttribute("width", "2000");
        svg.setAttribute("height", "1000");

        Element memory border = createElement("rect");
        border.setAttribute("width", "2000");
        border.setAttribute("height", "1000");
        border.setAttribute("stroke", "black");
        border.setAttribute("stroke-width", "4px");
        border.setAttribute("fill", "transparent");

        Element memory rect = createElement("rect");
        rect.setAttribute("width", "1920");
        rect.setAttribute("height", "920");
        rect.setAttribute("x", "40");
        rect.setAttribute("y", "40");
        // rect.setAttribute("stroke", "black");
        rect.setAttribute("transform", utils.rotate(int256(1 * -1), 500, 500));
        rect.setAttribute("fill", fill(seed));
        svg.appendChild(rect);
        svg.appendChild(border);

        uint256 numObjects = (_hash(transformSeed) % 7) + 1;

        Element memory g = recursion(transformSeed, seed, numObjects);

        svg.appendChild(g);

        return svg.draw();
    }

    function _hash(uint256 num) public pure returns (uint256) {
        return uint256(keccak256(abi.encode(num)));
    }

    function circle(uint256 seed) internal pure returns (Element memory circle) {
        uint256 cx = (_hash(seed + 1) % 1500) + 250;
        uint256 cy = (_hash(seed + 2) % 500) + 250;
        uint256 r = (_hash(seed + 3) % 100) + 5;
        circle = createElement("circle");
        circle.setAttribute("cx", utils._toString(cx));
        circle.setAttribute("cy", utils._toString(cy));
        circle.setAttribute("r", utils._toString(r));
        circle.setAttribute("fill", fill(seed + 4));
    }

    function rect(uint256 seed) internal pure returns (Element memory rect) {
        uint256 width = (_hash(seed + 1) % 900) + 100;
        uint256 height = (_hash(seed + 2) % 1500) + 100;
        uint256 x = (_hash(seed + 3) % 1500) + 250;
        uint256 y = (_hash(seed + 4) % 500) + 250;
        rect = createElement("rect");
        rect.setAttribute("width", utils._toString(width));
        rect.setAttribute("height", utils._toString(height));
        rect.setAttribute("x", utils._toString(x));
        rect.setAttribute("y", utils._toString(y));
        rect.setAttribute("rx", "2");
        // rect.setAttribute("stroke", "black");
        // rect.setAttribute("stroke-width", "4px");
        rect.setAttribute("fill", fill(seed + 3));
    }

    function fill(uint256 seed) internal pure returns (string memory fill) {
        uint256 r = _hash(seed + 1) % 255;
        uint256 g = _hash(seed + 2) % 255;
        uint256 b = _hash(seed + 3) % 255;
        uint256 a = (_hash(seed + 4) % 5) + 5;
        fill = utils.rgb(r, g, b);
    }

    function recursion(uint256 transformSeed, uint256 seed, uint256 numObjects) public returns (Element memory) {
        Element memory nextG;

        if (numObjects == 0) {
            return nextG;
        }
        Element memory g = createElement("g");

        int256 _rotate = int256(_hash(transformSeed) % 20) - 10;
        int256 _skew = int256(_hash(transformSeed + 1) % 20) - 10;

        string memory transform = string(abi.encodePacked(utils.rotate(_rotate, 500, 500), utils.skewX(_skew)));
        g.setAttribute("transform", transform); // add random rotate and skew amounts

        //create one or more objects
        // -circle
        // -lines
        // -triangle
        // -rect
        Element memory nextObject;
        uint256 object = _hash(seed) % 2;

        if (object == 0) {
            nextObject = rect(seed + 2);
        } else {
            nextObject = circle(seed + 2);
        }

        g.appendChild(nextObject);
        numObjects--;

        nextG = recursion(transformSeed + 1, seed + 20, numObjects);

        g.appendChild(nextG);

        return g;
    }






    function clock(int256 timeZoneOffset) public view returns (string memory) {
        uint256 timestamp = uint256(int256(block.timestamp) + timeZoneOffset * 1 hours);
        uint256 hour = DateTime.getHour(timestamp);
        uint256 minute = DateTime.getMinute(timestamp);
        uint256 second = DateTime.getHour(timestamp);
        hour = hour <= 12 ? hour : hour - 12;

        Element memory svg = createElement("svg");
        svg.setAttribute("xmlns", "http://www.w3.org/2000/svg");
        svg.setAttribute("width", "1000");
        svg.setAttribute("height", "1000");

        Element memory circle = createElement("circle");
        circle.setAttribute("cx", "500");
        circle.setAttribute("cy", "500");
        circle.setAttribute("r", "400");
        circle.setAttribute("fill", utils.rgb(247, 237, 226));
        circle.setAttribute("stroke", utils.rgb(29, 29, 29));
        circle.setAttribute("stroke-width", "10px");
        svg.appendChild(circle);

        //get the hour markers
        Element memory defs = createElement("defs");
        Element memory marker = createElement("line");
        marker.setAttribute("id", "hourMark");
        marker.setAttribute("x1", "500");
        marker.setAttribute("x2", "500");
        marker.setAttribute("y1", "160");
        marker.setAttribute("y2", "100");
        marker.setAttribute("stroke", "rgb(29, 29, 29)");
        marker.setAttribute("stroke-width", "8px");
        marker.setAttribute("stroke-linecap", "round");
        defs.appendChild(marker);
        svg.appendChild(defs);

        Element memory use = createElement("use");
        for (uint256 i = 0; i < 12; i++) {
            use.setAttribute("href", "#hourMark");
            use.setAttribute("transform", utils.rotate(int256(30 * i), 500, 500));
            svg.appendChild(use);
        }

        Element memory clockHand = createElement("line");
        Element memory rotateAnimation = createElement("animateTransform");
        // minute hand
        clockHand.setAttribute("x1", "500");
        clockHand.setAttribute("y1", "520");
        clockHand.setAttribute("x2", "500");
        clockHand.setAttribute("y2", "200");
        clockHand.setAttribute("stroke", utils.rgb(29, 29, 29));
        clockHand.setAttribute("stroke-width", "6px");
        clockHand.setAttribute("stroke-linecap", "round");

        int256 angle = int256(6 * minute);

        angle = angle + ((int256(second) * 6) / 60);
        clockHand.setAttribute("transform", utils.rotate(angle, 500, 500));

        rotateAnimation.setAttribute("attributeName", "transform");
        rotateAnimation.setAttribute("type", "rotate");
        rotateAnimation.setAttribute("from", string(abi.encodePacked(utils._toString(uint256(angle)), " 500 500")));
        rotateAnimation.setAttribute("to", string(abi.encodePacked(utils._toString(uint256(angle) + 360), " 500 500")));

        rotateAnimation.setAttribute("dur", "3600s");
        rotateAnimation.setAttribute("repeatCount", "indefinite");
        clockHand.appendChild(rotateAnimation);
        svg.appendChild(clockHand);//appending clears the attributes and children of the child. does not clear name, so we can reuse it for the element of the same type

        // hour hand
        clockHand.setAttribute("x1", "500");
        clockHand.setAttribute("y1", "520");
        clockHand.setAttribute("x2", "500");
        clockHand.setAttribute("y2", "270");
        clockHand.setAttribute("stroke", utils.rgb(29, 29, 29));
        clockHand.setAttribute("stroke-width", "12px");
        clockHand.setAttribute("stroke-linecap", "round");

        angle = int256(30 * hour);
        angle = angle + ((int256(minute) * 30) / 60);

        clockHand.setAttribute("transform", utils.rotate(angle, 500, 500));

        rotateAnimation.setAttribute("attributeName", "transform");
        rotateAnimation.setAttribute("type", "rotate");
        rotateAnimation.setAttribute("from", string(abi.encodePacked(utils._toString(uint256(angle)), " 500 500")));
        rotateAnimation.setAttribute("to", string(abi.encodePacked(utils._toString(uint256(angle) + 360), " 500 500")));

        rotateAnimation.setAttribute("dur", "43200s");
        rotateAnimation.setAttribute("repeatCount", "indefinite");
        clockHand.appendChild(rotateAnimation);

        svg.appendChild(clockHand);

                // second hand
        clockHand.setAttribute("x1", "500");
        clockHand.setAttribute("y1", "570");
        clockHand.setAttribute("x2", "500");
        clockHand.setAttribute("y2", "110");
        clockHand.setAttribute("stroke", "red");
        clockHand.setAttribute("stroke-width", "4px");
        clockHand.setAttribute("stroke-linecap", "round");
        clockHand.setAttribute("transform", utils.rotate(int256(6 * second), 500, 500));

        rotateAnimation.setAttribute("attributeName", "transform");
        rotateAnimation.setAttribute("type", "rotate");
        rotateAnimation.setAttribute("from", string(abi.encodePacked(utils._toString(6 * second), " 500 500")));
        rotateAnimation.setAttribute("to", string(abi.encodePacked(utils._toString((6 * second) + 360), " 500 500")));
        rotateAnimation.setAttribute("dur", "60s");
        rotateAnimation.setAttribute("repeatCount", "indefinite");
        clockHand.appendChild(rotateAnimation);
        svg.appendChild(clockHand); 



        Element memory center = createElement("circle");
        center.setAttribute("cx", "500");
        center.setAttribute("cy", "500");
        center.setAttribute("r", "10");
        center.setAttribute("fill", utils.rgb(29, 29, 29));
        svg.appendChild(center);

        return svg.draw();
    }
}
