pragma solidity ^0.8.13;


import {Element, utils} from './SVG.sol';

contract SVGConsumer {

    

    function randomDots(uint seed, uint dots) public pure returns (string memory) {

        Element memory svg;
        svg.createElement("svg");
        svg.setAttribute("xmlns","http://www.w3.org/2000/svg");
        svg.setAttribute("width", "2000");
        svg.setAttribute("height", "1000");

        Element memory rect;
        rect.createElement("rect");
        rect.setAttribute("width", "2000");
        rect.setAttribute("height", "1000");
        rect.setAttribute("stroke", "black");
        rect.setAttribute("stroke-width", "4px");
        rect.setAttribute("fill", "white");
        svg.appendChild(rect);


        

        for(uint i=0; i<dots; i++) {
            uint _hash = uint(keccak256(abi.encode(seed + i)));
            
            uint cy = uint(keccak256(abi.encode(_hash + 1))) % 1000;
            uint cx = uint(keccak256(abi.encode(_hash + 2))) % 2000;
            uint r = uint(keccak256(abi.encode(_hash + 3))) % 25 + 5;

            uint _r = uint(keccak256(abi.encode(_hash + 4))) % 255;
            uint _g = uint(keccak256(abi.encode(_hash + 5))) % 255;
            uint _b = uint(keccak256(abi.encode(_hash + 6))) % 255;
            uint _a = (uint(keccak256(abi.encode(_hash + 7))) % 5) + 5;
            string memory fill = utils.rgb(_r,_g,_b);            
            if(_hash % 100 < 5) {
                Element memory rect;
                rect.createElement("rect");
                rect.setAttribute("x", utils._toString(cx));
                rect.setAttribute("y", utils._toString(cy));
                rect.setAttribute("width", utils._toString(r));
                rect.setAttribute("height", utils._toString(r));
                rect.setAttribute("fill", fill);
                rect.setAttribute("z-index", "1000");
                svg.appendChild(rect);
                
            }
            else {
                 Element memory circle;
                circle.createElement("circle");
                circle.setAttribute("cx", utils._toString(cx));
                circle.setAttribute("cy",utils._toString(cy));
                circle.setAttribute("r", utils._toString(r));
                circle.setAttribute("fill", fill);
                svg.appendChild(circle);

            }


           
        }

        return svg.draw();


    }

    function art(uint transformSeed, uint seed) public returns(string memory) {

        Element memory svg;

        svg.createElement("svg");
        svg.setAttribute("xmlns","http://www.w3.org/2000/svg");
        svg.setAttribute("width", "2000");
        svg.setAttribute("height", "1000");

        Element memory border;
        border.createElement("rect");
        border.setAttribute("width", "2000");
        border.setAttribute("height", "1000");
        border.setAttribute("stroke", "black");
        border.setAttribute("stroke-width", "4px");
        border.setAttribute("fill", "transparent");
        
        Element memory rect;
        rect.createElement("rect");
        rect.setAttribute("width", "1920");
        rect.setAttribute("height", "920");
        rect.setAttribute("x", "40");
        rect.setAttribute("y", "40");
        // rect.setAttribute("stroke", "black");
        rect.setAttribute("transform", utils.rotate(int(1 * -1), 500, 500));
        rect.setAttribute("fill", fill(seed));
        svg.appendChild(rect);
        svg.appendChild(border);

        uint numObjects = (_hash(transformSeed) % 7) + 1;

        Element memory g = recursion(transformSeed,seed,numObjects);

        svg.appendChild(g);




        return svg.draw();

    }

    function _hash(uint num) public pure returns (uint) {
        return uint(keccak256(abi.encode(num)));
    }

    function circle(uint seed) internal pure returns (Element memory circle) {
        uint cx = (_hash(seed + 1) % 1500) + 250;
        uint cy = (_hash(seed + 2) % 500) + 250;
        uint r = (_hash(seed + 3) % 100)  + 5;
        circle.createElement("circle");
        circle.setAttribute("cx", utils._toString(cx));
        circle.setAttribute("cy",utils._toString(cy));
        circle.setAttribute("r", utils._toString(r));
        circle.setAttribute("fill", fill(seed + 4));

    }


    function rect(uint seed) internal pure returns(Element memory rect) {
        uint width = (_hash(seed + 1) % 900) + 100;
        uint height = (_hash(seed + 2) % 1500) + 100;
        uint x = (_hash(seed + 3) % 1500) + 250;
        uint y = (_hash(seed + 4) % 500) + 250;
        rect.createElement("rect");
        rect.setAttribute("width", utils._toString(width));
        rect.setAttribute("height", utils._toString(height));
        rect.setAttribute("x", utils._toString(x));
        rect.setAttribute("y", utils._toString(y));
        rect.setAttribute("rx", "2");
        // rect.setAttribute("stroke", "black");
        // rect.setAttribute("stroke-width", "4px");
        rect.setAttribute("fill", fill(seed + 3));


    }

    function fill(uint seed) internal pure returns(string memory fill) {
        uint r = _hash(seed + 1) % 255;
        uint g = _hash(seed + 2) % 255;
        uint b = _hash(seed + 3) % 255;
        uint a = (_hash(seed + 4) % 5) + 5;
        fill = utils.rgb(r,g,b);

    }


    function recursion(uint transformSeed, uint seed,uint numObjects) public returns(Element memory) {
        Element memory nextG;

        

        if(numObjects == 0) {
            return nextG;
        }
        Element memory g;
        g.createElement("g");

        int _rotate = int(_hash(transformSeed) % 5) - 10;
        int _skew = int(_hash(transformSeed+1) % 5) - 10;

        string memory transform = string(abi.encodePacked(utils.rotate(_rotate,500,500), utils.skewX(_skew)));
        g.setAttribute("transform", transform); // add random rotate and skew amounts

        //create one or more objects
        // -circle
        // -lines
        // -triangle
        // -rect
        Element memory nextObject;
        uint object =  _hash(seed) % 2;

        if(object == 0){
            nextObject = rect(seed+2);
        }
        else {
            nextObject = circle(seed+2);
        }


        g.appendChild(nextObject);
        numObjects --;

        nextG = recursion(transformSeed, seed + 20, numObjects);

        g.appendChild(nextG);

        return g;


        
    }






    // // taken from ERC721A
    // function _toString(uint256 value) internal pure virtual returns (string memory str) {
    //     assembly {
    //         // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
    //         // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
    //         // We will need 1 word for the trailing zeros padding, 1 word for the length,
    //         // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
    //         let m := add(mload(0x40), 0xa0)
    //         // Update the free memory pointer to allocate.
    //         mstore(0x40, m)
    //         // Assign the `str` to the end.
    //         str := sub(m, 0x20)
    //         // Zeroize the slot after the string.
    //         mstore(str, 0)

    //         // Cache the end of the memory to calculate the length later.
    //         let end := str

    //         // We write the string from rightmost digit to leftmost digit.
    //         // The following is essentially a do-while loop that also handles the zero case.
    //         // prettier-ignore
    //         for { let temp := value } 1 {} {
    //             str := sub(str, 1)
    //             // Write the character to the pointer.
    //             // The ASCII index of the '0' character is 48.
    //             mstore8(str, add(48, mod(temp, 10)))
    //             // Keep dividing `temp` until zero.
    //             temp := div(temp, 10)
    //             // prettier-ignore
    //             if iszero(temp) { break }
    //         }

    //         let length := sub(end, str)
    //         // Move the pointer 32 bytes leftwards to make room for the length.
    //         str := sub(str, 0x20)
    //         // Store the length.
    //         mstore(str, length)
    //     }
    // }


}

