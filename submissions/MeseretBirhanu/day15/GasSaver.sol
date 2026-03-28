// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../day12/AthenaToken.sol";

contract GasSaver{

    error NotContributor();

    AthenaToken public tokenContract;
    address public owner;

    struct Contributor{
        address wallet;
        bool isVerified;
        uint8 level;
         string name;
    }
    mapping(address => Contributor) public records;

    event addContributor(address indexed , string);
    event sentReward(string  , uint256);

     constructor(address _addr){
      owner = msg.sender;
     tokenContract = AthenaToken(_addr);

    }

    modifier onlyOwner(){
         require(msg.sender == owner, "only for owners!");
         _;
    }

   

    function register(address[] calldata _wallet ,string[] calldata _names, bool[] calldata _verified, uint8[] calldata _level) public {
        uint256 length = _names.length;
        for(uint256 i =0; i< length; i++){
             records[_wallet[i]] = Contributor(_wallet[i] , _verified[i] , _level[i] ,_names[i] );
            emit addContributor(_wallet[i] , _names[i] );

        }
    }
    function reward(address _addr  ,uint256 _amount) public onlyOwner payable {

        if(records[_addr].wallet!= address(0)  ){
            revert NotContributor();
        }
        Contributor memory _to = records[_addr];
        require(_to.isVerified , "not verified!");


     bool success = tokenContract.transfer(_addr, _amount);
    require(success, "ATH transfer failed!");
     emit sentReward(_to.name ,msg.value );

    }
}