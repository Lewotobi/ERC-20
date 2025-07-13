// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title OrcaCoin
 * @dev Simple ERC-20 Token with full transfer, approve, and optional mint/burn
 */
contract OrcaCoin {
    string public name = "OrcaCoin";
    string public symbol = "ORCA";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * (10 ** decimals);
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(balanceOf[from] >= value, "From balance too low");
        require(allowance[from][msg.sender] >= value, "Allowance too low");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    function mint(uint256 value) public onlyOwner {
        totalSupply += value;
        balanceOf[owner] += value;

        emit Transfer(address(0), owner, value);
    }

    function burn(uint256 value) public onlyOwner {
        require(balanceOf[owner] >= value, "Burn amount exceeds balance");

        balanceOf[owner] -= value;
        totalSupply -= value;

        emit Transfer(owner, address(0), value);
    }
}
