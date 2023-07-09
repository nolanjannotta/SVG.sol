pragma solidity ^0.8.13;

import "./utils.sol" as utils;

struct Element {
    string name;
    bytes attributes;
    bytes children;
}

function renderElement(Element memory self) pure returns (bytes memory) {
    if (bytes(self.name).length == 0) {
        return bytes("");
    }

    return abi.encodePacked("<", self.name, " ", self.attributes, ">", self.children, "</", self.name, ">");
}

function appendChild(Element memory self, Element memory child) pure returns (Element memory) {
    self.children = abi.encodePacked(self.children, child.renderElement());
    child.clear();
    return self;
}

// function createElement(Element memory self, string memory name) pure returns(Element memory) {
//     self.name = name;
//     return self;

// }

function createElement(string memory name) pure returns (Element memory element) {
    element.name = name;
    return element;
}

function setAttribute(Element memory self, string memory attribute, string memory value)
    pure
    returns (Element memory)
{
    self.attributes = abi.encodePacked(self.attributes, attribute, '="', value, '" ');
    return self;
}

function clear(Element memory self) pure returns (Element memory) {
    // self.name = "";
    self.children = "";
    self.attributes = "";
    return self;
}

function draw(Element memory self) pure returns (string memory) {
    return string(renderElement(self));
}

using {setAttribute, appendChild, clear, renderElement, draw} for Element global;
