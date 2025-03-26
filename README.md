# 24kbHelper
该仓库用于帮助如何减少Solidity合约的字节码大小，以通过24kb的大小限制

## 工厂模式

## 关于修饰符
根据以太坊官方[文章](https://ethereum.org/en/developers/tutorials/downsizing-contracts-to-fight-the-contract-size-limit/#remove-modifiers)提醒，使用修饰符`modifier`会比使用`检查函数`更占用空间。
为了验证及获取更多信息，编写了demo来测试一下。

