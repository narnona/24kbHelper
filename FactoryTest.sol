// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyERC20 is ERC20 {
    constructor() ERC20("MyToken", "MTK") {}
}

contract Factory {
    function createToken() external {
        new MyERC20();
    }
}

contract FactoryTest {
    function getMyERC20Szie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(MyERC20).creationCode;  // 4507 
        bytes memory runtimeCode = type(MyERC20).runtimeCode;    // 3554
        return (creationCode.length, runtimeCode.length);
    }

    function getFactorySzie() external pure returns(uint256, uint256) {
        bytes memory creationCode = type(Factory).creationCode;   // 4690 
        bytes memory runtimeCode = type(Factory).runtimeCode;     // 4662
        return (creationCode.length, runtimeCode.length);
    }
}
