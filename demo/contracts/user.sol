pragma solidity ^0.4.24;

contract user {

  struct userStruct {
    string userName;
    address userAddress;
    uint index;
  }

  struct userListStruct {
    address userAddress;
    uint index;
  }

  address[] private userAddresses;              //存储所有地址
  string[] private userNames;                   //存储所有用户名

  mapping (string => userListStruct) userListMap;          //便于用用户名查找地址
  mapping (address => userStruct) userMap;                 //便于用地址查找用户名

  function userNameExist(string _userName) public constant returns (bool) {   //检验用户名是否存在
    if( userNames.length == 0) return false;
    return (keccak256(userNames[userListMap[_userName].index]) == keccak256(_userName));
  }//string 不能直接用==比较，使用hash函数转换比较较为便捷

  function userAddressExist(address _userAddress)public constant returns (bool) {    //检验地址是否存在
    if(userAddresses.length == 0) return false;
    return  (userAddresses[userMap[_userAddress].index] == _userAddress);
  }

function createUser (string _userName, address _userAddress)public returns (uint) {   //创建用户返回index
  require(!userAddressExist(_userAddress));
  require(!userNameExist(_userName));

  userAddresses.push(_userAddress);
  userNames.push(_userName);

  userMap[_userAddress] = userStruct({
                                         userName : _userName,
                                         userAddress : _userAddress,
                                         index : userNames.length - 1
    });
  userListMap[_userName] = userListStruct({
                                            userAddress : _userAddress,
                                            index : userAddresses.length - 1
    });
    return userAddresses.length - 1;
}

function inquireUser(address _userAddress)public constant returns (string, address, uint) {   //根据地址查找用户信息
  require(userAddressExist(_userAddress));

  return (
    userMap[_userAddress].userName,
    userMap[_userAddress].userAddress,
    userMap[_userAddress].index
    );
}

}
