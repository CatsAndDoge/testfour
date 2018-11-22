let Web3 = require('web3');
let web3;

if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

let from = web3.eth.accounts[0];

//编译合约
let source = "pragma solidity ^0.4.24;
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

    event printUserName(string _name);

    function userNameExist(string _userName) public constant returns (bool) {   //检验用户名是否存在
      if( userNames.length == 0)    return false;
      return (keccak256(userNames[userListMap[_userName].index]) == keccak256(_userName));
    }//string 不能直接用==比较，使用hash函数转换比较较为便捷

    function userAddressExist(address _userAddress)public constant returns (bool) {    //检验地址是否存在
      if(userAddresses.length == 0)    return false;
      return  (userAddresses[userMap[_userAddress].index] == _userAddress);
    }

    function createUser (string _userName)public returns (uint) {   //创建用户返回index
      require(!userAddressExist(msg.sender));
      require(!userNameExist(_userName));

      userAddresses.push(msg.sender);
      userNames.push(_userName);

      userMap[msg.sender] = userStruct({
                                         userName : _userName,
                                         userAddress : msg.sender,
                                         index : userAddresses.length - 1
      });
      userListMap[_userName] = userListStruct({
                                            userAddress : msg.sender,
                                            index : userNames.length - 1
      });

      printUserName(_userName);                                                     //监听事件，返回用户名
      return userAddresses.length - 1;
    }

    function inquireUserA(address _userAddress)public constant returns (string, address, uint) {   //根据地址查找用户信息
      require(userAddressExist(_userAddress));

      return (
        userMap[_userAddress].userName,
        userMap[_userAddress].userAddress,
        userMap[_userAddress].index
     );
    }

    function inquireUserN(string _userName)public constant returns (string, address, uint) {   //根据用户名查找用户信息
      require(userNameExist(_userName));
      address _userAddress = userListMap[_userName].userAddress;

      return (
        userMap[_userAddress].userName,
        userMap[_userAddress].userAddress,
        userMap[_userAddress].index
       );
}

    function changeUserName(string _name)public returns (bool) { //修改用户姓名
      require(userAddressExist(msg.sender));

      string initName = userMap[msg.sender].userName;
      uint initIndex = userMap[msg.sender].index;

      delete userListMap[initName];
      userListMap[_name] = userListStruct({
                                            userAddress : msg.sender,
                                            index : initIndex
      });
      userMap[msg.sender].userName = _name;

      userNames[initIndex] = _name;
      printUserName(_name);
    
      return true;
    }

/*
                   以及修改其余用户信息的函数
*/

    function deleteUser()public returns (bool){ //删除用户信息，删除成功返回true
      delete userListMap[userMap[msg.sender].userName];
      delete userNames[userMap[msg.sender].index];
      delete userAddresses[userMap[msg.sender].index];
      delete userMap[msg.sender];

      return true;
    
    }

}
";
let calcCompiled = web3.eth.compile.solidity(source);

console.log(calcCompiled);
console.log("ABI definition:");
console.log(calcCompiled["info"]["abiDefinition"]);

//得到合约对象
let abiDefinition = calcCompiled["info"]["abiDefinition"];
let calcContract = web3.eth.contract(abiDefinition);

//2. 部署合约

//2.1 获取合约的代码，部署时传递的就是合约编译后的二进制码
let deployCode = calcCompiled["code"];

//2.2 部署者的地址，当前取默认账户的第一个地址。
let deployeAddr = web3.eth.accounts[0];

//2.3 异步方式，部署合约
let myContractReturned = calcContract.new({
    data: deployCode,
    from: deployeAddr
}, function singup(err, myContract) {
    if (!err) {
        // 注意：这个回调会触发两次
        //一次是合约的交易哈希属性完成
        //另一次是在某个地址上完成部署

        // 通过判断是否有地址，来确认是第一次调用，还是第二次调用。
        if (!myContract.address) {
            console.log("contract deploy transaction hash: " + myContract.transactionHash) //部署合约的交易哈希值

            // 合约发布成功后，才能调用后续的方法
        } else {
            console.log("contract deploy address: " + myContract.address) // 合约的部署地址
			alert(document.getElementById("singup").value);//获取输入的用户名
            //使用transaction方式调用，写入到区块链上
            myContract.createUser.sendTransaction(document.getElementById("singup").value,{
                from: deployeAddr
            });

            console.log("after contract deploy, call:" + myContract.getCount.call());
        }

        // 函数返回对象`myContractReturned`和回调函数对象`myContract`是 "myContractReturned" === "myContract",
        // 所以最终`myContractReturned`这个对象里面的合约地址属性也会被设置。
        // `myContractReturned`一开始返回的结果是没有设置的。
    }
});

//注意，异步执行，此时还是没有地址的。
console.log("returned deployed didn't have address now: " + myContractReturned.address);

//使用非回调的方式来拿到返回的地址，但你需要等待一段时间，直到有地址，建议使用上面的回调方式。
/*
setTimeout(function(){
  console.log("returned deployed wait to have address: " + myContractReturned.address);
  console.log(myContractReturned.getCount.call());
}, 20000);
*/

//如果你在其它地方已经部署了合约，你可以使用at来拿到合约对象
//calcContract.at(["0x50023f33f3a58adc2469fc46e67966b01d9105c4"]);

