pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/user.sol";

contract testUser{
    user _user = user(DeployedAddresses.user());

    function testCreateUsesr() public{                 //测试创建用户
        uint testIndex = _user.createUser("yellow Tang");
        uint index = 0;

        Assert.equal(testIndex, index, "createuser is false");
    }

 /*   function testInquireUserA() public{            //测试通过地址查询用户信息
        string testName = "yellow Tang";
        address testAddress = msg.sender;
        string  testName;
        address testAddress;
        uint testIndex;
        (testName, testAddress, testIndex) = _user.inquireUserA(msg.sender);

        Assert.equal(testName, "yellow Tang", "name of inquireuserA is false");
        Assert.equal(testAddress, msg.sender, "address of inquireuserA is false");
        Assert.equal(testIndex, 0, "index of inquireuserA is false");
    }

    function testInquireuserN() public{            //测试通过用户名查询用户信息
        string testName = "yellow Tang";
        address testAddress = msg.sender;
        uint testIndex = 0;

        Assert.equal(_user.inquireUserN(testName), (testName, testAddress, testIndex), "it is equal");
    }

    function testChangeUserName() public{       //测试修改用户姓名
        Assert.equal(_user.ChangeUserName("blue Tang"), true, "it is equal");
    }

    function testdeleteUser() public{            //测试删除用户信息
        Assert.equal(_user.deleteUser(), true, "it is equal");
    }
    */
}
