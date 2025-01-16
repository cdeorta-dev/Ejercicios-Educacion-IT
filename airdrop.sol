// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract airdrop{


    function spreadmoney(address[] calldata accounts) external payable {
       
       
        //len
        require(accounts.length>0,"no account");
        require(msg.value>0,"no money");
        uint256 amountPerAccount = msg.value / accounts.length;
        for (uint256 i=0; i < accounts.length; i++){
                payable(accounts[i]).transfer(amountPerAccount);
            
        }
    }
}