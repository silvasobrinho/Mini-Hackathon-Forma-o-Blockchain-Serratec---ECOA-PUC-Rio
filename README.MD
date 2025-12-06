# 🚀 Sistema de Doações Descentralizado - Web3

> **Mini Hackathon - Formação Blockchain Serratec | ECOA PUC-Rio**

Este projeto é um DApp (Decentralized Application) desenvolvido durante o Hackathon, focado na criação de um sistema transparente de doações utilizando Smart Contracts na rede Ethereum.

---

## 👥 Integrantes do Grupo

* Adriana Franco Marins
* Giovane da Silva Sobrinho
* José Augusto dos Santos Junior
* Paulo Junior
* Rafael Vieira Camara

---

## 📄 Sobre o Projeto

O objetivo é solucionar a falta de transparência em sistemas de doação tradicionais. Utilizando a blockchain, garantimos que qualquer pessoa possa auditar o saldo arrecadado e que apenas o beneficiário cadastrado possa realizar o saque.

### Funcionalidades
* **Smart Contract (`doacoes.sol`):**
    * [cite_start]Registro imutável do beneficiário no momento do deploy[cite: 3, 11].
    * [cite_start]Proteção contra ataques de reentrada (`nonReentrant`)[cite: 9].
    * [cite_start]Controle de saldo total e individual por doador[cite: 4, 21].
    * [cite_start]Saque restrito e seguro apenas para o beneficiário[cite: 14].
* **Frontend (`index.html`):**
    * Conexão com carteira MetaMask via Web3.js.
    * Visualização em tempo real do total arrecadado.
    * Interface para realizar doações e saques.

---

## 🛠 Tecnologias Utilizadas

* **Solidity (v0.8.19):** Linguagem do Smart Contract.
* **Web3.js:** Biblioteca para interação com a Blockchain.
* **HTML5 / CSS3:** Interface do usuário.
* **Remix IDE:** Para compilação e deploy do contrato.
* **MetaMask:** Carteira para assinatura das transações.

---

## ⚙️ Como Executar o Projeto

### 1. Deploy do Contrato
1. Abra o arquivo `doacoes.sol` no [Remix IDE](https://remix.ethereum.org/).
2. Compile o contrato com a versão `0.8.19` ou superior.
3. Na aba "Deploy", insira o endereço da carteira do **Beneficiário** no campo do construtor.
4. Faça o deploy na rede de teste (ex: Sepolia) ou na VM local.

### 2. Configuração do Frontend
Para que o site converse com o contrato, é necessário atualizar o arquivo `index.html`:

1. Copie o **Endereço do Contrato** gerado no Remix e cole na variável:
   ```javascript
   const contractAddress = "SEU_ENDERECO_AQUI";