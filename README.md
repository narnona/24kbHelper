# 24kbHelper
该仓库用于帮助如何减少Solidity合约的字节码大小，以通过24kb的大小限制。
<br>

## 工厂模式
首先需要知道相关知识：**创建时字节码** 与 **运行时字节码**。 <br>
- 创建时字节码，包含初始化逻辑的，在remix中就称为“bytecodes”, 也称“creation bytecodes”  <br>
- 运行时字节码，最终存储到区块链上的，remix中为“runtime bytecodes”, 也称“deployed bytecodes”

看文章了解更多：https://medium.com/coinmonks/the-difference-between-bytecode-and-deployed-bytecode-64594db723df <br>
如果合约是使用了工厂模式，通过`new`关键字来创建一个新合约，那被创建合约的**创建时字节码**是需要嵌入到合约中的（作为模板去创建）。 <br>
相关demo: [FactoryTest.sol](https://github.com/narnona/24kbHelper/blob/main/FactoryTest.sol) <br>
相关推文：https://x.com/0xkaka1379/status/1904542618102464830
<br>

## 关于修饰符 modifier
根据以太坊官方[文章](https://ethereum.org/en/developers/tutorials/downsizing-contracts-to-fight-the-contract-size-limit/#remove-modifiers)提醒，使用修饰符`modifier`会比使用`检查函数`更占用空间。
<br>
为了验证及获取更多信息，编写了demo来测试一下: [ModifierTest.sol](https://github.com/narnona/24kbHelper/blob/main/ModifierTest.sol)
<br>
测试数据：
|       | 直接嵌入检查       | 使用修饰符       | 使用检查函数       |
|-----------|-----------|-----------|-----------|
| 使用 1 次  | (490, 462) | (490, 462)  | (500, 472) |
| 使用 2 次  | (727, 699)  | (727, 699)  | (613, 585)  |
| 使用 3 次  | (964, 936)  | (964, 936) | (726, 698) |

通过demo结果也可以大概猜到`modifier`是在编译时进行转化，转为直接嵌入。
另外，也理解了openzeppelin的`modifier`内部是使用了函数。因此，如果你的修饰符是这样的：
``` solidity
modifier onlyOwner() {
    if(msg.sender != owner) revert NotOwner();
    _;
}
```
那可以改为：
``` solidity
function _checkOwner() internal view {
    if(msg.sender != owner) revert NotOwner();
}

modifier onlyOwner() {
    _checkOwner();
    _;
}
```
