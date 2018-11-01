pragma solidity ^0.4.24;

import "../contracts/user.sol";

contract topic {

    struct topicStruct {                                      //话题结构
      string title;
      mapping (uint => messegeStruct) messegeStructMap;    //第一条消息为话题的介绍
      address user;
      uint time;
      uint messegeSize;
      uint index;
    }

    struct topicListStruct {                              //话题辅助结构
        string title;
        uint index;
    }

    struct messegeStruct {                               //话题下的信息结构
      string messege;
      address user;
      uint time;
      uint index;
    }


    string[] titles;               //存储所有标题
    user u;

    mapping (uint => topicStruct) topicStructMap;   //话题序号对应话题
    mapping (string => topicListStruct) topicListStructMap;    //话题标题对应话题序号

    function topicExist(string _title) public returns (bool) {                     //检验话题是否存在
        if (titles.length == 0)    return false;
        return (keccak256(titles[inquireTopicIndex(_title)]) == keccak256(_title));
    }

    function inquireTopicIndex(string _title) public returns (uint) {                  //通过话题标题来查找话题index
        return topicListStructMap[_title].index;
    }

    function createTopic(string _title, string _topicMessege) public returns (uint) { //创建话题,返回index
      require(!topicExist(_title));                               //检验话题是否存在
      titles.push(_title);                           

      topicListStructMap[_title] = topicListStruct({
                                title : _title,
                                index : titles.length
      });

      topicStructMap[titles.length] = topicStruct({
                                  title : _title,
                                  user : msg.sender,
                                  time : now,
                                  messegeSize : 1,
                                  index : titles.length
        });
      topicStructMap[titles.length].messegeStructMap[0] = messegeStruct(_topicMessege,msg.sender,now,0);
      return titles.length;
    }

    function changeTopic(string _title,string _topicMessege)public returns (uint) { //修改话题信息，返回index(仅限题主修改)
        require(u.userAddressExist(msg.sender));                                //检验用户是否存在
        require(topicExist(_title));                                            //检验话题是否存在
        
        topicStruct thisTopic = topicStructMap[inquireTopicIndex(_title)];

        require(msg.sender == thisTopic.user);                //检验是否是题主
        thisTopic.messegeStructMap[0]=_topicMessege;

        return thisTopic.index;
        
    }

    function inquireTopicT(string _title) public returns (string, address, uint, uint, uint){          //通过标题查找话题

    }

    function inquireTopicI(uint _index) public returns (string, address, uint, uint, uint) {           //通过index查找话题
        
    }

    function deleteTopic(string _title) public returns (bool){                                    //通过标题删除话题(仅限题主)

    }


    function createMessege(string _messege, string _title) public returns(uint){ //在话题下追加消息，返回index
      require(u.userAddressExist(msg.sender));                                           //检验账户是否存在
      require(topicExist(_title));                                                       //检验话题是否存在

      topicStruct  thisTopic = topicStructMap[_title];
      thisTopic.messegeStructMap[thisTopic.messegeSize] = messegeStruct(_messege, msg.sender, now,thisTopic.messegeSize);
      thisTopic.messegeSize++;
      return thisTopic.index;
    }

    function changeMessege(string _title, string _messege)public returns (uint){ //修改话题下的信息，返回index(仅限答主修改)
        require(u.userAddressExist(msg.sender));                                     //检验用户是否存在
        require(topicExist(_title));                                                 //检验话题是否存在

        topicStruct thisTopic = topicStructMap[inquireTopicIndex(_title)];
        //
    }

    //查找话题下的信息

    //删除话题下的信息（
}
