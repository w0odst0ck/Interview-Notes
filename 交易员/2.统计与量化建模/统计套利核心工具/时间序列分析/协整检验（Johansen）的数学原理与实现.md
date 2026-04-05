
# 数学原理 + Python 实现 + 配对交易 / 多资产套利实战

这是**统计套利、多资产配对、投资组合对冲**的**工业级标准检验方法**，比 Engle-Granger 两步法更强大、更专业。

---

# 一、一句话核心

**Johansen 检验 = 同时检验多个资产之间的协整关系数量**

- 支持 **2 个及以上资产**
- 找出所有**长期均衡关系**
- 直接给出**协整向量（对冲比例）**
- 机构量化、多因子套利、配对交易必用

---

# 二、先回顾：协整是什么？

两个**非平稳**价格序列，它们的**线性组合是平稳**的

→ 这种稳定关系叫**协整**

→ 价差会均值回归 → **能做套利**

---

# 三、为什么要用 Johansen？（对比 EG 两步法）

表格

|方法|优点|缺点|
|---|---|---|
|Engle-Granger|简单|只能 2 个资产、依赖主从关系|
|**Johansen**|**多资产、多协整关系、直接出对冲矩阵**|数学稍复杂|

**做策略永远优先用 Johansen！**

---

# 四、数学原理（极简清晰版）

## 1. 模型基础：VAR 向量自回归

多个资产价格组成向量 Xt​：

$$ X_t = A_1 X_{t-1} + \dots + A_k X_{t-k} + \mu_t $$

## 2. 写成向量误差修正模型（VECM）

Johansen 检验的核心式子：

$$ \Delta X_t = \Pi X_{t-1} + \Gamma_1 \Delta X_{t-1} + \dots + \mu_t $$

### 关键矩阵：Π

$Π=αβ^′$

- β = **协整向量**（套利对冲比例！）
- α = 修正系数（回归速度）

## 3. 检验逻辑

Π 的秩 r = **协整关系数量**

- r=0：无协整 ❌
- r≥1：有协整 ✅
- r=n：全平稳

## 4. 两个统计量（看结果用）

1. **Trace 统计量**
2. **Max-Eigen 统计量**

判断标准：

**统计量 > 临界值 → 拒绝原假设 → 存在协整**

---

# 五、最关键结论（实战必记）

Johansen 检验直接给你：

1. **有没有协整关系**
2. **有几个**
3. **最优对冲比例 β**

**β 就是配对交易的对冲权重！**

---

# 六、Python 完整实现（直接跑）

```python
import numpy as np
import pandas as pd
from statsmodels.tsa.vector_ar.vecm import coint_johansen

# ===================== 1. 生成协整价格数据 =====================
np.random.seed(42)
n = 1000
x = np.cumsum(np.random.randn(n))    # 资产1
y = 1.2 * x + np.random.randn(n) * 2 # 资产2（协整）
z = 0.8 * x + np.random.randn(n) * 2 # 资产3（协整）

# 组合成矩阵（每列一个资产）
data = np.column_stack([x, y, z])
```

```python
# ===================== 2. Johansen 协整检验核心函数 =====================
def johansen_test(data, det_order=0, k_ar_diff=1):
    """
    det_order: 0 - 无常数项; 1 - 常数项; 2 - 常数+趋势
    k_ar_diff: 滞后阶数
    """
    jres = coint_johansen(data, det_order, k_ar_diff)
    
    print("===== Johansen 协整检验结果 =====")
    print("特征值 (Eigenvalues):\n", jres.eig)
    print("\n协整向量 ( yout 矩阵，每一列是一个协整向量 ):\n", np.round(jres.yot, 3))
    
    print("\n=== Trace 统计量 ===")
    for i, (trace, crit) in enumerate(zip(jres.trace, jres.cvt[:,2])):
        print(f"H0: 协整秩 ≤ {i} | trace={trace:.2f} | 95%临界={crit:.2f} → {'✅ 有协整' if trace > crit else '❌ 无协整'}")

    print("\n=== Max-Eigen 统计量 ===")
    for i, (me, crit) in enumerate(zip(jres.max_eig, jres.cvm[:,2])):
        print(f"H0: 协整秩 ≤ {i} | max_eig={me:.2f} | 95%临界={crit:.2f} → {'✅ 有协整' if me > crit else '❌ 无协整'}")
    
    return jres

# 执行检验
jres = johansen_test(data)
```

---

# 七、实战怎么看结果？

## 1. 看 Trace / Max-Eigen

只要 **统计量 > 95% 临界值**

→ **存在协整关系**

## 2. 看协整向量 β（最重要！）

```plaintext
协整向量:
[[-0.3   1.2   -0.8 ]  # 资产1权重
 [ 1.0  -0.5    0.3 ]  # 资产2权重
 [-0.5   0.2    1.0 ]] # 资产3权重
```

**第一列 β 就是最优对冲比例！**

构造平稳价差：

```plaintext
spread = β1*P1 + β2*P2 + β3*P3
```

---

# 八、配对交易直接用法

## 双资产 Johansen 输出示例：

```plaintext
β = [-0.3, 1.0]
```

价差：

$spread=−0.3P_A​+1.0P_B​$

**交易信号：**

- spread 偏高 → 多 A 空 B
- spread 偏低 → 空 A 多 B
- 回归均值 → 平仓

---

# 九、极简总结（必须背）

- **Johansen = 多资产协整检验**
- **Trace / Max-Eigen > 临界值 → 协整成立 ✅**
- **协整向量 β = 配对交易对冲比例**
- **价差平稳 → 均值回归 → 套利赚钱**
- **机构统计套利标配工具**