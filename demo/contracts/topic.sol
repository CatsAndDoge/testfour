pragma solidity ^0.4.24;

//import "../contracts/user.sol";

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

    mapping (string => topicStruct) topicStructMap;   //标题对应话题

    function createTopic(string _title, string _topicMessege) public returns (uint) {
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
}
