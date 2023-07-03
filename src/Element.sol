pragma solidity ^0.8.13;

struct Element {
    string name;
    string attributes;
    string children;
}






function renderElement(Element memory self) pure returns(string memory) {
    return string(abi.encodePacked("<", self.name, " ", self.attributes, ">", self.children, "</", self.name, ">"));
}

function appendChild(Element memory self, Element memory child) pure returns (Element memory) {    
    self.children = string(abi.encodePacked(self.children, child.renderElement()));
    // child.clear();
    return self;

}


function createElement(Element memory self, string memory name) pure returns(Element memory) {
    self.name = name;
    return self;

}

function setAttribute(Element memory self, string memory attribute, string memory value) pure returns (Element memory) {
    self.attributes = string(abi.encodePacked(self.attributes, attribute, '="', value, '" '));
    return self;

    
}


function clear(Element memory self) pure returns(Element memory) {
    self.name = "";
    self.children = "";
    self.attributes = "";
    return self;

}

function draw(Element memory self) pure returns(string memory) {
    return renderElement(self);
}









using {createElement, setAttribute, appendChild,clear,renderElement, draw} for Element global;