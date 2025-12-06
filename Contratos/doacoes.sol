// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Contrato de Doação com Beneficiário Único
/// @notice Permite que qualquer pessoa doe ETH para um beneficiário único. Registra contribuições individuais,
/// permite saque apenas pelo beneficiário, emite eventos para transparência e protege contra reentrância.
contract ContratoDoacao {
    // --- Estado ---
    address public immutable beneficiario;
    uint256 public totalDoado;

    // contribuições por doador
    mapping(address => uint256) private contribuicoes;

    // --- Eventos ---
    event DoacaoRecebida(address indexed doador, uint256 valor);
    event Saque(address indexed beneficiario, uint256 valor);

    // --- Reentrancy guard (padrão simples) ---
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    // --- Erros customizados (mais gas eficiente que require com string) ---
    error SomenteBeneficiario();
    error ValorZero();
    error SaldoInsuficiente(uint256 disponivel, uint256 solicitado);

    // --- Modificadores ---
    modifier somenteBeneficiario() {
        if (msg.sender != beneficiario) revert SomenteBeneficiario();
        _;
    }

    modifier nonReentrant() {
        if (_status == _ENTERED) revert();
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }

    /// @dev Define o beneficiário ao implantar o contrato
    /// @param _beneficiario endereço que poderá sacar os fundos
    constructor(address _beneficiario) {
        require(_beneficiario != address(0), "Beneficiario invalido");
        beneficiario = _beneficiario;
        _status = _NOT_ENTERED;
    }

    // --- Funções de doação ---

    /// @notice Doe ETH ao contrato (qualquer pessoa)
    function doar() external payable {
        _processarDoacao(msg.sender, msg.value);
    }

    /// @notice Função receive para aceitar transfers diretas (ex: remetente envia ETH sem chamar doar())
    receive() external payable {
        _processarDoacao(msg.sender, msg.value);
    }

    /// @dev Processa a doação comum: valida valor > 0, atualiza mapping e total, e emite evento
    function _processarDoacao(address _doador, uint256 _valor) internal {
        if (_valor == 0) revert ValorZero();

        contribuicoes[_doador] += _valor;
        totalDoado += _valor;

        emit DoacaoRecebida(_doador, _valor);
    }

    // --- Saque pelo beneficiário ---

    /// @notice Permite que o beneficiário saque um valor específico
    /// @param _quantia quantidade em wei a ser sacada
    function sacar(uint256 _quantia) external somenteBeneficiario nonReentrant {
        uint256 saldo = address(this).balance;
        if (_quantia > saldo) revert SaldoInsuficiente(saldo, _quantia);

        // transferir usando call (padrão recomendado)
        (bool sucesso, ) = payable(beneficiario).call{value: _quantia}("{}");
        require(sucesso, "Transferencia falhou");

        emit Saque(beneficiario, _quantia);
    }

    /// @notice Permite que o beneficiário saque todo o saldo do contrato
    function sacarTudo() external somenteBeneficiario nonReentrant {
        uint256 saldo = address(this).balance;
        if (saldo == 0) revert SaldoInsuficiente(0, 0);

        (bool sucesso, ) = payable(beneficiario).call{value: saldo}("");
        require(sucesso, "Transferencia falhou");

        emit Saque(beneficiario, saldo);
    }

    // --- Consultas públicas ---

    /// @notice Retorna quanto um doador específico contribuiu
    /// @param _doador endereço do doador
    function contribuicaoDe(address _doador) external view returns (uint256) {
        return contribuicoes[_doador];
    }

    /// @notice Retorna o saldo atual guardado no contrato
    function saldoContrato() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Retorna o total acumulado de doações desde a implantação
    function totalDoacoes() external view returns (uint256) {
        return totalDoado;
    }
}