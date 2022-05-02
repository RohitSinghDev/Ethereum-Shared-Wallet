// SPDX-License-Identifier: MIT


pragma solidity ^0.8.9;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable{

    using SafeMath for uint;

    event AllowanceChanged(address indexed _forWho, address indexed _fromWho, uint _amountOld, uint _amountNew);
    
    mapping(address => uint)public allowance;

    function isOwner()public view returns(bool){
        return msg.sender == owner();
    }

    function setAllowance(address _who, uint _amount)public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowance(uint _amount){
        require(isOwner()|| allowance[msg.sender]>=_amount,"you are not allowed");
        _;
    }

    function reduceAllowance(address _who, uint _amount)internal{
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub(_amount);
    }





}