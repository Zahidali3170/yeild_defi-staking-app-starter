// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//reward token contract
contract RWD {
    string public name = "Reward Token";
    string public symbol = "RWD";
    uint256 totalSuply = 1000000000000000000000000000;
    uint8 decimals = 18;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) private _allowances;
    event Transfer(address indexed from, address indexed t0, uint256);
    event Approval(address indexed owner, address indexed spender, uint256);

    constructor() {
        balanceOf[msg.sender] = totalSuply;
    }

    function transfer(address reciver, uint256 numtoken) public returns (bool) {
        require(numtoken <= balanceOf[msg.sender]);
        balanceOf[msg.sender] -= numtoken;
        balanceOf[reciver] += numtoken;
        emit Transfer(msg.sender, reciver, numtoken);
        return true;
    }

    function approval(address _spender, uint256 _token)
        public
        returns (bool success)
    {
        _allowances[msg.sender][_spender] = _token;

        emit Approval(msg.sender, _spender, _token);

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _token
    ) public returns (bool success) {
        uint256 allowance = _allowances[_from][msg.sender];
        require(balanceOf[_from] >= _token && allowance >= _token);
        balanceOf[_to] += _token;
        balanceOf[_from] -= _token;
        _allowances[_from][msg.sender] -= _token;
        emit Transfer(_from, _to, _token);
        return true;
    }
}
