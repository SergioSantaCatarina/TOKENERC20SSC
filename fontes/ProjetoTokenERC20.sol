// SPDX-License-Identifier: GPL-3.0
// Contrato adaptado do exemplo apresentado pelo prof. Cassiano

pragma solidity ^0.8.0;

interface IERC20{

    //getters
    function totalSuplay() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns(uint256);
    //functions
    function transfer(address recipient, uint256 amount) external returns(bool);
    function approve(address spender, uint256 amount) external returns(bool);
    function transferFrom(address spender, address recipient, uint256 amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256);
}

contract ProjetoTokenERC20 is IERC20{

    string public constant nome = "SSC Coin";
    string public constant simbolo = "SSC";
    uint8 public constant decimais = 18;
    mapping (address => uint256) saldo;
    mapping (address => mapping(address => uint256)) delegados;
    uint256 suprimentoTotal = 10 ether;

    constructor(){
        saldo[msg.sender] = suprimentoTotal;
    }

    function totalSuplay() public override view returns (uint256){
        return suprimentoTotal;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256){
        return saldo[tokenOwner];
    }

    function transfer(address destinatario, uint256 qtdTokens) public override returns(bool){
        require(qtdTokens <= saldo[msg.sender]);
        saldo[msg.sender] = saldo[msg.sender] - qtdTokens;
        saldo[destinatario] = saldo[destinatario] + qtdTokens;
        emit Transfer(msg.sender, destinatario, qtdTokens);
        return true;
    }

    function approve(address delegado, uint256 qtdTokensAprovada) public override returns(bool){
        delegados[msg.sender][delegado] = qtdTokensAprovada;
        emit Approval(msg.sender, delegado, qtdTokensAprovada);
        return true;
    }
    function allowance(address owner, address delegado) public override view returns(uint256){
        return delegados[owner][delegado];
    }

    function transferFrom(address owner, address destinatario, uint256 qtdTokensTransferidos) public override returns(bool){
        require(qtdTokensTransferidos <= saldo[owner]);
        require(qtdTokensTransferidos <= delegados[owner][msg.sender]);
        saldo[owner] = saldo[owner] - qtdTokensTransferidos;
        delegados[owner][msg.sender] = delegados[owner][msg.sender]- qtdTokensTransferidos;
        saldo[destinatario] = saldo[destinatario] + qtdTokensTransferidos;
        emit Transfer(owner, destinatario,qtdTokensTransferidos);
        return true;
    }
}