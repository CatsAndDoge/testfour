pragma solidity ^0.4.24;

import "../contracts/user.sol";
import "../contracts/pages.sol";

contract topic {

    struct topicStruct {                                      //话题结构
      string title;
      //mapping (uint => messegeStruct) messegeStructMap;    
      uint[] indexs;                                        //存储该话题下的所有信息的index,第一条消息为话题的介绍
      address user;
      string pages;                                        //用于存储话题所属的分类
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
    messegeStruct[] messeges;      //存储所有信息
    user u;

    mapping (uint => topicStruct) topicStructMap;   //话题序号对应话题
    mapping (string => topicListStruct) topicListStructMap;    //话题标题对应话题序

    function topicExist(string _title) public returns (bool) {                     //检验话题是否存在
        if (titles.length == 0)    return false;
        return (keccak256(titles[inquireTopicIndex(_title)]) == keccak256(_title));
    }

    function inquireTopicIndex(string _title) public returns (uint) {                  //通过话题标题来查找话题index
        return topicListStructMap[_title].index;
    }

    function createTopic(string _title, string _topicMessege, string _pages) public returns (uint) { //创建话题,返回index
      require(!topicExist(_title));                               //检验话题是否存在

      titles.push(_title);   
      messeges.push(messegeStruct({                                  //生成新的信息结构并放入数组中
                                    messege : _topicMessege,
                                    user : msg.sender,
                                    time : now,
                                    index : messeges.length
      }));

      uint[] memory idxs = new uint[](1);             //建立用于信息序号的数组
      idxs[0] = messeges.length - 1;                  //将第一条信息，即话题的简介的序号放入数组第一个

      topicListStructMap[_title] = topicListStruct({
                                title : _title,
                                index : titles.length
      });

      topicStructMap[titles.length] = topicStruct({
                                  title : _title,
                                  indexs : idxs,
                                  user : msg.sender,
                                  pages: _pages,
                                  time : now,
                                  messegeSize : 1,
                                  index : titles.length
        });
      //topicStructMap[titles.length].messegeStructMap[0] = messegeStruct(_topicMessege,msg.sender,now,0);
      return titles.length;
    }

    function changeTopic(string _title,string _topicMessege)public returns (uint) { //修改话题信息，返回index(仅限题主修改)
        require(u.userAddressExist(msg.sender));                                //检验用户是否存在
        require(topicExist(_title));                                            //检验话题是否存在
        
        topicStruct thisTopic = topicStructMap[inquireTopicIndex(_title)];

        require(msg.sender == thisTopic.user);                //检验是否是题主
        //thisTopic.messegeStructMap[0].messege=_topicMessege;
        messeges[thisTopic.indexs[0]].messege = _topicMessege;
        messeges[thisTopic.indexs[0]].time = now;

        return thisTopic.index;
        
    }

 /*   function showTopicIndex() public returns (uint[]){                //返回用户的所有话题的index
        require(u.userAddressExist(msg.sender));                      //检验用户是否存在
        //
    }

    function inquireTopicT(string _title) public returns (string, address, uint, uint, uint){          //通过标题查找话题

    }

    function inquireTopicI(uint _index) public returns (string, address, uint, uint, uint) {           //通过index查找话题
        
    }

    function deleteTopic(string _title) public returns (bool){                                    //通过标题删除话题(仅限题主)

    }

*/
    function createMessege(string _messege, string _title) public returns(uint){ //在话题下追加消息，返回index
      require(u.userAddressExist(msg.sender));                                           //检验用户是否存在
      require(topicExist(_title));                                                       //检验话题是否存在

      topicStruct  thisTopic = topicStructMap[topicListStructMap[_title].index];
      //thisTopic.messegeStructMap[thisTopic.messegeSize] = messegeStruct(_messege, msg.sender, now,thisTopic.messegeSize);
      //thisTopic.messegeSize++;
      messeges.push(messegeStruct({
                                    messege : _messege,
                                    user : msg.sender,
                                    time : now,
                                    index : messeges.length
      }));
      thisTopic.indexs.push(messeges.length - 1);
      return messeges.length - 1;
    }
/*
    function showMessegeIndex() public returns (uint[]){                      //返回用户的所有消息的index
        require(user.userAddressExist(msg.sender));                                      //检验用户是否存在
        //uint[] indexs = new uint[]
    }
*/
    function changeMessege(string _title, uint _index, string _messege)public returns (uint){ //修改话题下的信息，返回index(仅限答主修改)
        require(u.userAddressExist(msg.sender));                                     //检验用户是否存在
        require(topicExist(_title));                                                 //检验话题是否存在

        topicStruct thisTopic = topicStructMap[inquireTopicIndex(_title)];
        messegeStruct thisMessege = messeges[_index];
        require(msg.sender == thisMessege.user);                                    //检验是否是答主
        thisMessege.messege = _messege;

        return thisMessege.index;
    }

    //查找话题下的信息

    //删除话题下的信息（
}
