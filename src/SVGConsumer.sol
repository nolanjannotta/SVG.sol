pragma solidity ^0.8.13;


import {Element} from './Element.sol';

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
            string memory fill = string(abi.encodePacked("rgb(", _toString(_r), ",", _toString(_g),",", _toString(_b), ")"));
            
            if(_hash % 100 < 5) {
                Element memory rect;
                rect.createElement("rect");
                rect.setAttribute("x", _toString(cx));
                rect.setAttribute("y", _toString(cy));
                rect.setAttribute("width", _toString(r));
                rect.setAttribute("height", _toString(r));
                rect.setAttribute("fill", fill);
                rect.setAttribute("z-index", "1000");
                svg.appendChild(rect);
                
            }
            else {
                 Element memory circle;
                circle.createElement("circle");
                circle.setAttribute("cx", _toString(cx));
                circle.setAttribute("cy",_toString(cy));
                circle.setAttribute("r", _toString(r));
                circle.setAttribute("fill", fill);
                svg.appendChild(circle);

            }


           
        }

        return svg.draw();


    }






    // taken from ERC721A
    function _toString(uint256 value) internal pure virtual returns (string memory str) {
        assembly {
            // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
            // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
            // We will need 1 word for the trailing zeros padding, 1 word for the length,
            // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
            let m := add(mload(0x40), 0xa0)
            // Update the free memory pointer to allocate.
            mstore(0x40, m)
            // Assign the `str` to the end.
            str := sub(m, 0x20)
            // Zeroize the slot after the string.
            mstore(str, 0)

            // Cache the end of the memory to calculate the length later.
            let end := str

            // We write the string from rightmost digit to leftmost digit.
            // The following is essentially a do-while loop that also handles the zero case.
            // prettier-ignore
            for { let temp := value } 1 {} {
                str := sub(str, 1)
                // Write the character to the pointer.
                // The ASCII index of the '0' character is 48.
                mstore8(str, add(48, mod(temp, 10)))
                // Keep dividing `temp` until zero.
                temp := div(temp, 10)
                // prettier-ignore
                if iszero(temp) { break }
            }

            let length := sub(end, str)
            // Move the pointer 32 bytes leftwards to make room for the length.
            str := sub(str, 0x20)
            // Store the length.
            mstore(str, length)
        }
    }


}

