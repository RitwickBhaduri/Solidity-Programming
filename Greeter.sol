pragma solidity ^0.4.0;

contract Greeter {
    string public yourName;
    
    function Greeter() public {
        yourName = "Wolrd";
    }
    
    function set(string name) public {
        yourName = name;
    }
    
    function hello() constant public returns (string) {
        return yourName;
    }
}
