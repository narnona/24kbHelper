# 24kbHelper
该仓库用于帮助如何减少Solidity合约的字节码大小，以通过24kb的大小限制。
<br>
### 背景
从 2016 年 11 月 22 日起，Spurious Dragon 硬分叉引入了 [EIP-170](https://eips.ethereum.org/EIPS/eip-170)，对智能合约增加了 24.576 KB 的大小限制。当你对一个合约添加过多功能时，可能会使得合约的(运行时)字节码超过 24.576 KB, 从而导致部署失败。 <br>
<br>
引入该限制是为了防止拒绝服务 (DOS) 攻击。从 gas 角度来看，对合约的任何调用都相对便宜。但是，合约调用对以太坊节点的影响会根据被调用合约代码的大小（从磁盘读取代码、预处理代码、将数据添加到 Merkle 证明）而不成比例地增加。<br> 
<br>
据此特性，攻击者可以部署一个很大的合约，合约内含有简单的函数。这样，攻击者只需要花费很少的 gas 去调用那个简单函数，就可以为网络造成大量工作。（类似于：你想要去某个地方，只有你一个人，却开着火车去）

### 拆分合约
> 合约大小限制的报错，就像是一面镜子，通过它你可以知道：你的合约太大了，你应该拆分一下。

拆分合约应该是你的首选方法。那么，如何将合约拆分成多个较小的合约？这通常会迫使你为合约设计一个良好的架构。<br>
<br>
可做如下思考：
- 哪些功能是属于同一类的？该类功能是否应该拥有一个自己的合约？
- 哪些功能不需要读取合约状态或只需要读取状态的特定子集？
- 可以把代码和逻辑分开吗？

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

### 参考
[ethereum.org:  Downsizing contracts to fight the contract size limit](https://ethereum.org/en/developers/tutorials/downsizing-contracts-to-fight-the-contract-size-limit/)
