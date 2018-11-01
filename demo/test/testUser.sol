pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/user.sol";

contract testUser{
    user _user = user(DeployedAddresses.user());

    function testCreateUsesr() public{                 //测试创建用户
        uint testIndex = _user.createUser("yellow Tang");
        uint index = 0;

        Assert.equal(testIndex, index, "it is equal");
    }

    function testInquireUserA() public{            //测试通过地址查询用户信息
        string testName = "yellow Tang";
        address testAddress = msg.sender;
        uint testIndex = 0;

        Assert.equal(_user.inquireUserA(msg.sender), (testName, testAddress, testIndex), "it is equal");
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
}
