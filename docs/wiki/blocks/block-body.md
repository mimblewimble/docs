# Transaction Body

General format of a **Transaction Body** in a Mimblewimble/Grin is basically a Mimblewimble transaction which consists of a list of **Inputs**, **Outputs** and **Kernels**.

| Field         | Description           | Size                 |
|:--------------|:----------------------|:---------------------|
| # inputs      | Number of inputs      | 8 bytes              |
| # outputs     | Number of outputs     | 8 bytes              |
| # kernels     | Number of kernels     | 8 bytes              |
| inputs        | Serialized inputs     | 34 bytes per input   |
| outputs       | Serialized outputs    | 42 bytes per output  |
| kernels       | Serialized kernels    | x bytes per kernel   |

The kernel size **x** depends on the kernel type. More details in its dedicated section below.

## Inputs

Each of the inputs consists of **Feature** and a **Commitment**.

| Field         | Description                             | Size                |
|:--------------|:----------------------------------------|:--------------------|
| Feature       | **Plain** (0x00) or **Coinbase** (0x01) | 1 byte              |
| Commitment    | Pedersen commitment                     | 33 bytes            |

## Outputs

Just as in case of the inputs, the outputs consist of **Feature** and a **Commitment** but in addition they also hold **Range proofs**

| Field                  | Description                             | Size                |
|:-----------------------|:----------------------------------------|:--------------------|
| Feature                | **Plain** (0x00) or **Coinbase** (0x01) | 1 byte              |
| Commitment             | Pedersen commitment                     | 33 bytes            |
| Range proof size **x** | Proves the transaction is net positive  | 8 bytes             |
| Range proof            | Proves the transaction is net positive  | **x** bytes         |

Note that the **range proof** is of a variable size which is indicated by its first 8 bytes.

## Kernels

Every kernel starts with **Kernel feature** which indicates how it should be deserialized. In each variant, the kernel concludes with an **Excess commitment** and a **Excess signature**. What differs them is what is in the middle. We will describe each variant separately

### Coinbase kernel

The most basic kernel that does not contain **Fee** nor **Lock height**.

| Field             | Description                                                                                       | Size                |
|:------------------|:--------------------------------------------------------------------------------------------------|:--------------------|
| Feature           | **Plain** (0x00), **Coinbase** (0x01), **Height Locked** (0x02) or **No recent duplicate** (0x03) | 1 byte              |
| Excess commitment | Pedersen commitment                                                                               | 33 bytes            |
| Excess signature  | Schnorr signature                                                                                 | 64 bytes            |

### Plain kernel

A kernel resulting from a transaction, unlike **Coinbase** kernel it also includes **Fee** billed for the transaction.

| Field             | Description                                                                                       | Size                |
|:------------------|:--------------------------------------------------------------------------------------------------|:--------------------|
| Feature           | **Plain** (0x00), **Coinbase** (0x01), **Height Locked** (0x02) or **No recent duplicate** (0x03) | 1 byte              |
| Fee               | Transaction fee                                                                                   | 8 bytes             |
| Excess commitment | Pedersen commitment                                                                               | 33 bytes            |
| Excess signature  | Schnorr signature                                                                                 | 64 bytes            |

### Height locked kernels

The first protocol **kernel** would always consist of **Feature**, **Fee**, **Lock height** and standard **Excess commitment** and **Signature**. Starting from the V2 protocol a specific type of kernel - **height locked** kernel supports the **lock height**.

| Field             | Description                                                                                       | Size                |
|:------------------|:--------------------------------------------------------------------------------------------------|:--------------------|
| Feature           | **Plain** (0x00), **Coinbase** (0x01), **Height Locked** (0x02) or **No recent duplicate** (0x03) | 1 byte              |
| Fee               | Transaction fee                                                                                   | 8 bytes             |
| Lock height       | Block height starting from which the kernel becomes valid                                         | 8 bytes             |
| Excess commitment | Pedersen commitment                                                                               | 33 bytes            |
| Excess signature  | Schnorr signature                                                                                 | 64 bytes            |

### NRD (No Recent Duplicate) kernels

( need help describing )

| Field             | Description                                                                                       | Size                |
|:------------------|:--------------------------------------------------------------------------------------------------|:--------------------|
| Feature           | **Plain** (0x00), **Coinbase** (0x01), **Height Locked** (0x02) or **No recent duplicate** (0x03) | 1 byte              |
| Fee               | Transaction fee                                                                                   | 8 bytes             |
| Lock height       | Block height starting from which the kernel becomes valid                                         | 8 bytes             |
| Excess commitment | Pedersen commitment                                                                               | 33 bytes            |
| Excess signature  | Schnorr signature                                                                                 | 64 bytes            |
