pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Demo.sol";

contract testDemo {
  Demo demo = Demo(DeployedAddresses.Demo());

  function testMix() public {
    uint testName = demo.mix(3);
    uint test = 6;

    Assert.equal(testName, test, "it it equal");
  }

}
