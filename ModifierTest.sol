// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 直接嵌入检查
contract Test01 {
    address private owner;

    error NotOwner();

    function setOwner01(address _newOwner) external {
        if(msg.sender != owner) revert NotOwner();
        owner = _newOwner;
    }

    function setOwner02(address _newOwner) external {
        if(msg.sender != owner) revert NotOwner();
        owner = _newOwner;
    }

    function setOwner03(address _newOwner) external {
        if(msg.sender != owner) revert NotOwner();
        owner = _newOwner;
    }
}

// 使用 modifier
contract Test02 {
    address private owner;

    error NotOwner();
    modifier onlyOwner() {
        if(msg.sender != owner) revert NotOwner();
        _;
    }

    function setOwner01(address _newOwner) external onlyOwner  {
       owner = _newOwner;
    }

    function setOwner02(address _newOwner) external onlyOwner  {
       owner = _newOwner;
    }

    function setOwner03(address _newOwner) external onlyOwner  {
       owner = _newOwner;
    }
}

// 使用检查函数
contract Test03 {
    address private owner;

    error NotOwner();
    function checkOwner() private view {
        if(msg.sender != owner) revert NotOwner();
    }

    function setOwner01(address _newOwner) external  {
        checkOwner();
        owner = _newOwner;
    }

    function setOwner02(address _newOwner) external  {
        checkOwner();
        owner = _newOwner;
    }

    function setOwner03(address _newOwner) external  {
        checkOwner();
        owner = _newOwner;
    }
}

contract ModifierTest {  // 分别获取各个合约的creation bytecode 和 runtime bytecode 大小
    function getTest01Szie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(Test01).creationCode;   // 获取创建时字节码（包含初始化逻辑）
        bytes memory runtimeCode = type(Test01).runtimeCode;     // 运行时字节码
        return (creationCode.length, runtimeCode.length);
    }

    function getTest02Szie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(Test02).creationCode;
        bytes memory runtimeCode = type(Test02).runtimeCode;
        return (creationCode.length, runtimeCode.length);
    }

    function getTest03Szie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(Test03).creationCode;
        bytes memory runtimeCode = type(Test03).runtimeCode;
        return (creationCode.length, runtimeCode.length);
    }
}
