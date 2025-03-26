// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 使用public
contract Test01 {
    uint256 public a;
    address public b;

    function setA(uint256 _a) external {
        a = _a;
    }

    function setb(address _b) external {
        b = _b;
    }
}

// 使用internal
contract Test02 {
    uint256 internal a;
    address internal b;

    function setA(uint256 _a) external {
        a = _a;
    }

    function setb(address _b) external {
        b = _b;
    }
}

// 使用private
contract Test03 {
    uint256 private a;
    address private b;

    function setA(uint256 _a) external {
        a = _a;
    }

    function setb(address _b) external {
        b = _b;
    }
}

contract Test04 {
    uint256 public a;
    address public b;

    function setA(uint256 _a) external {
        a = _a;
    }

    function setb(address _b) external {
        b = _b;
    }

    function getA() external view returns(uint256) {
        return a;
    }

    function getB() external view returns(address) {
        return b;
    }
}

contract Test05 {
    uint256 public a;
    address public b;
    uint256 public c;

    function setA(uint256 _a) external {
        a = _a;
    }

    function setb(address _b) external {
        b = _b;
    }
}

contract Test06 {
    uint256 internal a;
    address internal b;
    uint256 internal c;

    function setA(uint256 _a) external {
        a = _a;
    }

    function setb(address _b) external {
        b = _b;
    }
}


contract VariablesVisibilityTest {
    function getTest01Szie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(Test01).creationCode;  // 705
        bytes memory runtimeCode = type(Test01).runtimeCode;    // 677
        return (creationCode.length, runtimeCode.length);
    }

    function getTest02Szie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(Test02).creationCode;  // 501
        bytes memory runtimeCode = type(Test02).runtimeCode;    // 473
        return (creationCode.length, runtimeCode.length);
    }

    function getTest03Szie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(Test03).creationCode;  // 501
        bytes memory runtimeCode = type(Test03).runtimeCode;    // 473
        return (creationCode.length, runtimeCode.length);
    }

    function getTest04Szie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(Test04).creationCode;  // 835
        bytes memory runtimeCode = type(Test04).runtimeCode;    // 807
        return (creationCode.length, runtimeCode.length);
    }

    function getTest05Szie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(Test05).creationCode;   // 752
        bytes memory runtimeCode = type(Test05).runtimeCode;     // 724
        return (creationCode.length, runtimeCode.length);
    }

    function getTest06Szie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(Test06).creationCode;   // 501
        bytes memory runtimeCode = type(Test06).runtimeCode;     // 473
        return (creationCode.length, runtimeCode.length);
    }
}
