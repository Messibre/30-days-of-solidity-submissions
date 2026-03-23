// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);   

    event Transfer(address indexed from, address indexed to, uint256 value); 
}

contract AthenaToken is IERC20{
    string public name = "Athena Token";
    string public symbol = "ATH";
    uint8 public decimals = 18;
    uint256 public maxSupply = 10000000 * 10**18;
    address public owner;

    uint256 public override totalSupply;

    mapping(address =>uint256) public override balanceOf;

    constructor(uint256 _initialSupply){
        owner = msg.sender;
        uint256 initialSupply = _initialSupply *10**decimals;
        require(initialSupply > 0 , "invalid Amount");
        require( initialSupply <= maxSupply , "amount more than max supply");

        totalSupply = initialSupply;
        balanceOf[msg.sender] += initialSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }
    function mint(uint256 _amount) public {
        uint256 amount = _amount * 10**decimals; 

        require(msg.sender == owner , "not eligible to mint");
        require(amount > 0 , "invalid amount");
        require(totalSupply + amount <= maxSupply , "total amount more than max supply");

        totalSupply += amount;
        balanceOf[msg.sender] += amount;

        emit Transfer(address(0), msg.sender, amount);

    }

    function transfer(address _to , uint256 _amount) public override returns (bool)  {
           require(_to != address(0) , "invalid Address");
           require(_amount > 0 , "invalid amount");
           require(_amount <= balanceOf[msg.sender] , "insufficient tokens");

           balanceOf[_to] += _amount;
           balanceOf[msg.sender] -= _amount;

           emit Transfer(msg.sender, _to, _amount);
           return true;
    }

}