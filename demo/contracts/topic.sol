pragma solidity ^0.4.24;

import "../contracts/user.sol";

contract topic {

    struct topicStruct {
      string title;
      mapping (uint => messegeStruct) messegeStructMap;    //第一条消息为话题的介绍
      address user;
      uint time;
      uint messegeSize;
      uint index;
    }

    struct messegeStruct {
      string messege;
      address user;
      uint time;
      uint index;
    }

    string[] titles;               //存储所有标题
    user u;

    mapping (string => topicStruct) topicStructMap;   //标题对应话题

    function createTopic(string _title, string _topicMessege) public returns (uint) {//创建话题,返回index
      titles.push(_title);

      topicStructMap[_title] = topicStruct({
                                  title : _title,
                                  user : msg.sender,
                                  time : now,
                                  messegeSize : 1,
                                  index : titles.length
        });
      topicStructMap[_title].messegeStructMap[0] = messegeStruct(_topicMessege,msg.sender,now,1);
      return titles.length;
    }

    function createMessege(string _messege, string _title) public returns(uint){ //在话题下追加消息，返回index
      require(u.userAddressExist(msg.sender));//检验账户是否存在

      topicStruct storage thisTopic = topicStructMap[_title];
      thisTopic.messegeStructMap[thisTopic.messegeSize] = messegeStruct(_messege, msg.sender, now,thisTopic.messegeSize + 1);
      thisTopic.messegeSize++;
      return thisTopic.messegeSize;
    }
}
