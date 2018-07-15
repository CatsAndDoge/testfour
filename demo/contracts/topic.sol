pragma solidity ^0.4.24;

import "user.sol";

contract topic {

    struct topicStruct {
      string title;
      messegeStruct[] messege;
      uint index;
    }

    struct messegeStruct {
      string messege;
      uint index;
    }

    topicStruct[] topicStructs;
    string[] titles;

    mapping (string => topicStruct) topicStructMap;
    

    function createTopic(string _title, address _topicer) public returns () {

    }
}
