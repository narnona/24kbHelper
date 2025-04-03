# 24kbHelper
该仓库用于帮助如何减少Solidity合约的字节码大小，以通过24kb的大小限制。
<br>
## 背景
从 2016 年 11 月 22 日起，Spurious Dragon 硬分叉引入了 [EIP-170](https://eips.ethereum.org/EIPS/eip-170)，对智能合约增加了 24.576 KB 的大小限制。当你对一个合约添加过多功能时，可能会使得合约的(运行时)字节码超过 24.576 KB, 从而导致部署失败。 <br>
<br>
引入该限制是为了防止拒绝服务 (DOS) 攻击。从 gas 角度来看，对合约的任何调用都相对便宜。但是，合约调用对以太坊节点的影响会根据被调用合约代码的大小（从磁盘读取代码、预处理代码、将数据添加到 Merkle 证明）而不成比例地增加。<br> 
<br>
据此特性，攻击者可以部署一个很大的合约，合约内含有简单的函数。这样，攻击者只需要花费很少的 gas 去调用那个简单函数，就可以为网络造成大量工作。（类似于：你想要去某个地方，只有你一个人，却开着火车去）

## 拆分合约
> 合约大小限制的报错，就像是一面镜子，通过它你可以知道：你的合约太大了，你应该拆分一下。

拆分合约应该是你的首选方法。那么，如何将合约拆分成多个较小的合约？这通常会迫使你为合约设计一个良好的架构。<br>
<br>
可做如下思考：
- 哪些功能是属于同一类的？该类功能是否应该拥有一个自己的合约？
- 哪些功能不需要读取合约状态或只需要读取状态的特定子集？
- 可以把代码和逻辑分开吗？

拆分方式：
1. 直接把部分的逻辑移到额外的合约，然后通过外部合约调用来连接。对于额外的合约，你可能需要定义权限，定义为只有原合约才能调用；
2. 如果这个额外的逻辑是无状态的，则可以定义为**库合约**。注意，函数要声明为`public`或`external`，这样库合约会部署到另外的地址，从而减少原合约的字节码。如果是声明为`internal`，则是内联到原合约中，字节码并不会减少；
3. 使用代理。

## 是否有合约创建逻辑？
需要先知道相关知识：**创建时字节码** 与 **运行时字节码**。 <br>
- 创建时字节码，包含初始化逻辑的，在remix中就称为“bytecodes”, 也称“creation bytecodes”  <br>
- 运行时字节码，最终存储到区块链上的，remix中为“runtime bytecodes”, 也称“deployed bytecodes”

看文章了解更多：https://medium.com/coinmonks/the-difference-between-bytecode-and-deployed-bytecode-64594db723df <br>
如果你合约中存有创建新合约的代码逻辑，也即通过`new`关键字来创建新合约，那被创建合约的**创建时字节码**是会嵌入到和你合约中的（可以理解成作为模板去创建）。 <br>
相关demo: [FactoryTest.sol](https://github.com/narnona/24kbHelper/blob/main/FactoryTest.sol) <br>
相关推文：https://x.com/0xkaka1379/status/1904542618102464830
<br>
改进思路：和拆分合约的思路一样，把`new`逻辑移到另外的合约。

<br>

## 关于修饰符 modifier
首先，你需要知道modifier的原理。`modifier`是在编译时，在代码层面进行转换的。
对于如下代码：
```
    modifier onlyOwner() {
        if(msg.sender != owner) revert NotOwner();
        _;
    }

    function setOwner(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }
```
相当于：
```
    function setOwner(address _newOwner) external {
        if(msg.sender != owner) revert NotOwner();
        owner = _newOwner;
    }
```
<br>

为了验证及获取更多信息，编写了demo来测试一下:[ModifierTest.sol](https://github.com/narnona/24kbHelper/blob/main/ModifierTest.sol)

<br>
测试得到的结果：(创建时字节码大小，运行时字节码大小)  

|       | 直接嵌入检查       | 使用修饰符       | 使用检查函数       |
|-----------|-----------|-----------|-----------|
| 使用 1 次  | (490, 462) | (490, 462)  | (500, 472) |
| 使用 2 次  | (727, 699)  | (727, 699)  | (613, 585)  |
| 使用 3 次  | (964, 936)  | (964, 936) | (726, 698) |

通过demo结果，直接嵌入的方式和使用修饰符的方式所用的字节码大小一样。也可以大概猜到`modifier`是在编译时进行转化，转为直接嵌入。
随着使用的次数增加，字节码的增加大小不容忽视。因此，如果你的修饰符是这样的：
``` solidity
modifier onlyOwner() {
    if(msg.sender != owner) revert NotOwner();
    _;
}
```
那应该改为：
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
