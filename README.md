# 24kbHelper
该仓库用于帮助如何减少Solidity合约的字节码大小，以通过24kb的大小限制

## 工厂模式

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
