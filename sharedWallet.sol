// SPDX-License-Identifier: MIT


pragma solidity ^0.8.9;

import "./Allowance.sol";


contract sharedWallet is Allowance{

 

    function renounceOwnership()public view onlyOwner override(Ownable){
        revert("cant renounce ownership");
    }

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    event MoneyMessageReceived(address indexed _from, uint _amount, bytes data);


    function withdrawMoney(address payable _to, uint _amount)public ownerOrAllowance(_amount) {

        require(_amount <= address(this).balance,"not enough funds in this contract");

        if(!isOwner()){
            reduceAllowance(msg.sender,_amount);
        }

        emit MoneySent(_to,_amount);

        _to.transfer(_amount);
    }

    function checkBalance()public view returns(uint) {

        return address(this).balance;

    }

    receive() external payable{

        emit MoneyReceived(msg.sender,msg.value);

    }

    fallback() external payable {

        emit MoneyMessageReceived(msg.sender, msg.value, msg.data);

    }
    
}