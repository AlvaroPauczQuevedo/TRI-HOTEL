# Documentação Técnica - Desligar.ps1

## 1. Visão Geral do Projeto

### 1.1 Descrição
Script PowerShell que exibe uma interface gráfica (GUI) com contagem regressiva para desligar o computador automaticamente. O usuário pode confirmar o desligamento imediato ou cancelar, encerrando a aplicação.

### 1.2 Objetivo
Proporcionar uma experiência visual amigável para o desligamento agendado do sistema, com feedback visual em tempo real do tempo restante.

---

## 2. Arquitetura do Sistema

### 2.1 Fluxo de Execução

```
┌─────────────────────────────────────────────────────────────┐
│                    INÍCIO DA EXECUÇÃO                       │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  1. Carregamento do Assembly System.Windows.Forms           │
│     (necessário para criar interface gráfica)               │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  2. Inicialização de variáveis                              │
│     • $tempoTotal = 120 (segundos)                          │
│     • $tempoRestante = 120 (contador regressivo)             │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  3. Criação da Janela (Form)                                │
│     • Configurações visuais (tamanho, posição, cores)       │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  4. Criação dos Componentes UI                              │
│     • Título, ícone, mensagem, timer, barra de progresso   │
│     • Botões Sim/Cancelar                                   │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  5. Configuração do Timer de Contagem                       │
│     • Intervalo de 1 segundo (1000ms)                      │
│     • Evento Tick para atualização da interface            │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  6. Exibição da Janela (ShowDialog)                        │
│     • Loop de eventos até fechamento                        │
└─────────────────────────┬───────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    FIM DA EXECUÇÃO                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Detalhamento de Cada Componente

### 3.1 Carregamento de Dependências

```powershell
Add-Type -AssemblyName System.Windows.Forms
```

| Aspecto | Descrição |
|---------|-----------|
| **Função** | Carrega o assembly Windows Forms necessário para criar elementos GUI |
| **Impacto no Usuário** | Sem isso, não há interface gráfica possível |
| **Manutenção** | Verificar se o .NET Framework está instalado (requer .NET 3.5+) |

---

### 3.2 Variáveis de Controle

```powershell
$tempoTotal = 120      # Tempo total em segundos (2 minutos)
$tempoRestante = $tempoTotal  # Contador regressivo
```

| Variável | Função | Valor Padrão |
|----------|--------|--------------|
| `$tempoTotal` | Define a duração total do timer | 120 segundos |
| `$tempoRestante` | Controla o tempo restante atual | Igual ao total |

**Interação com o Usuário:**
- O valor de `$tempoTotal` determina quanto tempo o usuário tem para decidir
- Ao reaching zero, o computador é desligado automaticamente

---

### 3.3 Formulário Principal (Janela)

```powershell
$form = New-Object System.Windows.Forms.Form
$form.Text = "Desligar Computador"
$form.Size = New-Object System.Drawing.Size(600, 370)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
$form.FormBorderStyle = "FixedDialog"
$form.ControlBox = $false
```

| Propriedade | Valor | Descrição |
|-------------|-------|-----------|
| Text | "Desligar Computador" | Título da janela |
| Size | 600x370 pixels | Dimensões da janela |
| StartPosition | CenterScreen | Centraliza na tela |
| TopMost | $true | Janela sempre visível |
| BackColor | RGB(245,245,245) | Cor de fundo clara |
| FormBorderStyle | FixedDialog | Borda fixa (não redimensionável) |
| ControlBox | $false | Remove botões de minimizar/fechar |

**Interação com o Usuário:**
- A janela sempre fica acima de outras aplicações
- Não pode ser redimensionada acidentalmente
- Não pode ser fechada pelo X (apenas pelos botões)

---

### 3.4 Título Principal

```powershell
$titulo = New-Object System.Windows.Forms.Label
$titulo.Text = "Desligar Computador"
$titulo.Font = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$titulo.ForeColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$titulo.Location = New-Object System.Drawing.Point(40, 32)
$titulo.AutoSize = $true
```

| Propriedade | Valor | Impacto Visual |
|-------------|-------|-----------------|
| Font | Segoe UI 22pt Bold | Texto grande e destacado |
| ForeColor | RGB(0,120,215) | Azul profissional |
| Location | (40, 32) | Posição no canto superior |

---

### 3.5 Ícone de Aviso

```powershell
$iconLabel = New-Object System.Drawing.Font("Segoe UI Emoji", 28)
$iconLabel.Text = [char]0x26A0  # Símbolo ⚠
$iconLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 193, 7)
```

| Aspecto | Descrição |
|---------|-----------|
| **Símbolo** | ⚠ (U+26A0) - Warning Sign |
| **Cor** | Amarelo RGB(255,193,7) |
| **Finalidade** | Alertar o usuário sobre ação crítica |

---

### 3.6 Mensagem Principal

```powershell
$mensagem.Text = "Deseja desligar o computador agora?"
$mensagem.Font = New-Object System.Drawing.Font("Segoe UI", 14)
$mensagem.ForeColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
```

| Elemento | Descrição |
|----------|-----------|
| **Texto** | Pergunta direta ao usuário |
| **Tamanho** | 14pt - legível mas não dominante |
| **Cor** | Cinza escuro (não preto puro) |

---

### 3.7 Timer (Contagem Regressiva)

```powershell
$timerLabel.Text = "02:00"
$timerLabel.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$timerLabel.ForeColor = [System.Drawing.Color]::FromArgb(200, 0, 0)
$timerLabel.Location = New-Object System.Drawing.Point(250, 130)
```

| Estado | Cor | Significado |
|--------|-----|-------------|
| > 30 segundos | Vermelho RGB(200,0,0) | Tempo normal |
| 10-30 segundos | Laranja RGB(255,140,0) | Atenção |
| ≤ 10 segundos | Vermelho RGB(200,0,0) | Urgente |

**Interação com o Usuário:**
- Feedback visual claro do tempo restante
- Mudança de cor alerta sobre o fim próximo

---

### 3.8 Barra de Progresso

```powershell
$progressBar.Location = New-Object System.Drawing.Point(100, 190)
$progressBar.Size = New-Object System.Drawing.Size(400, 25)
$progressBar.Style = "Continuous"
```

| Propriedade | Valor |
|-------------|-------|
| Largura | 400 pixels |
| Altura | 25 pixels |
| Estilo | Contínuo (sem segmentos) |

**Cálculo da Porcentagem:**
```powershell
$porcentagem = [math]::Round(($script:tempoRestante / $script:tempoTotal) * 100)
$progressBar.Value = $porcentagem
```

---

### 3.9 Botão "Sim" (Confirmar Desligamento)

```powershell
$btnSim.Text = "Sim"
$btnSim.Size = New-Object System.Drawing.Size(130, 44)
$btnSim.Location = New-Object System.Drawing.Point(170, 240)
$btnSim.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$btnSim.ForeColor = "White"
$btnSim.Add_Click({
    shutdown /s /t 0
})
```

| Propriedade | Valor |
|-------------|-------|
| Texto | "Sim" |
| Cor | Azul (confirmação) |
| Texto do botão | Branco |
| Ação | `shutdown /s /t 0` - desliga imediatamente |

**Comando de Desligamento:**
- `/s` = Shutdown
- `/t 0` = Tempo zero (imediatamente)

---

### 3.10 Botão "Cancelar"

```powershell
$btnNao.Text = "Cancelar"
$btnNao.Size = New-Object System.Drawing.Size(130, 44)
$btnNao.Location = New-Object System.Drawing.Point(320, 240)
$btnNao.BackColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
$btnNao.Add_Click({
    $form.Close()
})
```

| Propriedade | Valor |
|-------------|-------|
| Texto | "Cancelar" |
| Cor | Cinza (ação neutra) |
| Ação | Fecha o formulário sem desligar |

---

### 3.11 Timer de Contagem (System.Windows.Forms.Timer)

```powershell
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000  # 1 segundo
```

**Lógica do Tick (a cada segundo):**

```powershell
$timer.Add_Tick({
    # 1. Decrementa o contador
    $script:tempoRestante--
    
    # 2. Verifica se chegou a zero
    if ($script:tempoRestante -le 0) {
        $timer.Stop()
        shutdown /s /t 0  # Desliga automaticamente
    }
    
    # 3. Atualiza display do timer
    $minutos = [math]::Floor($script:tempoRestante / 60)
    $segundos = $script:tempoRestante % 60
    $timerLabel.Text = "$minutos`:$segundosStr"
    
    # 4. Atualiza barra de progresso
    $porcentagem = [math]::Round(($script:tempoRestante / $script:tempoTotal) * 100)
    $progressBar.Value = $porcentagem
    
    # 5. Altera cor conforme tempo restante
    if ($script:tempoRestante -le 10) {
        $timerLabel.ForeColor = [System.Drawing.Color]::FromArgb(200, 0, 0)
    } elseif ($script:tempoRestante -le 30) {
        $timerLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 140, 0)
    }
})
```

---

## 4. Guia de Manutenção

### 4.1 Como Alterar o Tempo do Timer

**Para alterar o tempo total:**

```powershell
# Linha 4 do arquivo
$tempoTotal = 120  # Altere este valor em segundos
```

| Tempo Desejado | Valor |
|----------------|-------|
| 30 segundos | 30 |
| 1 minuto | 60 |
| 2 minutos | 120 (padrão) |
| 5 minutos | 300 |

---

### 4.2 Como Alterar Cores

**Cor do título:**
```powershell
$titulo.ForeColor = [System.Drawing.Color]::FromArgb(0, 120, 215)  # Azul
```

**Cor do timer:**
```powershell
$timerLabel.ForeColor = [System.Drawing.Color]::FromArgb(200, 0, 0)  # Vermelho
```

**Cores disponíveis (RGB):**
- Vermelho: `(200, 0, 0)`
- Laranja: `(255, 140, 0)`
- Azul: `(0, 120, 215)`
- Verde: `(0, 150, 0)`
- Cinza: `(120, 120, 120)`

---

### 4.3 Como Alterar Tamanho da Janela

```powershell
$form.Size = New-Object System.Drawing.Size(600, 370)  # (largura, altura)
```

---

### 4.4 Como Alterar Posição dos Elementos

Cada elemento usa `Location = New-Object System.Drawing.Point(x, y)`:

| Ponto | Coordenada X | Coordenada Y |
|-------|--------------|--------------|
| Título | 40 | 32 |
| Ícone | 510 | 18 |
| Mensagem | 40 | 80 |
| Timer | 250 | 130 |
| Barra de progresso | 100 | 190 |
| Botão Sim | 170 | 240 |
| Botão Cancelar | 320 | 240 |

---

### 4.5 Solução de Problemas (Troubleshooting)

#### Problema 1: Script não executa (Erro de política de execução)

**Sintoma:**
```
O arquivo não pode ser carregado porque a execução de scripts está desabilitada.
```

**Solução:**
```powershell
# Execute no PowerShell como Administrador:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

#### Problema 2: Interface não aparece

**Sintoma:** Janela não abre ou fecha imediatamente

**Solução:**
1. Verificar se o .NET Framework está instalado
2. Executar com privilégios administrativos
3. Verificar se não há outro processo com o mesmo nome

---

#### Problema 3: Timer não atualiza

**Sintoma:** Timer fica estático

**Solução:**
```powershell
# Verificar se o timer foi iniciado
$timer.Start()

# Verificar se o intervalo está correto
$timer.Interval = 1000  # Deve ser 1000ms (1 segundo)
```

---

#### Problema 4: Comando shutdown não funciona

**Sintoma:** Botão "Sim" não desligar o computador

**Solução:**
1. Executar o script como Administrador
2. Verificar se o comando está habilitado:
```powershell
# Testar comando diretamente no terminal
shutdown /s /t 0
```

---

#### Problema 5: Caracteres especiais não aparecem

**Sintoma:** Ícone ⚠ aparece como "?"

**Solução:**
```powershell
# Usar código Unicode diretamente
$iconLabel.Text = [char]0x26A0
```

---

#### Problema 6: Formulário fecha ao pressionar Escape

**Sintoma:** Janela fecha acidentalmente

**Solução (remover comportamento):**
```powershell
# Comentar ou remover esta seção:
$form.Add_KeyDown({
    param($sender, $e)
    if ($e.KeyCode -eq "Escape") {
        $form.Close()
    }
})
```

---

### 4.6 Boas Práticas de Manutenção

1. **Sempre fazer backup** antes de modificar o script
2. **Testar em ambiente de teste** antes de aplicar em produção
3. **Documentar alterações** neste arquivo
4. **Usar variáveis configuráveis** no topo do arquivo para facilitar ajustes
5. **Manter consistência** nos estilos visuais

---

## 5. Estrutura de Arquivos

```
Projects/
└── Desligar.ps1          # Script principal
└── README.md             # Esta documentação
```

---

## 6. Requisitos do Sistema

| Requisito | Versão Mínima |
|-----------|---------------|
| Sistema Operacional | Windows 7 ou superior |
| PowerShell | 5.1 ou superior |
| .NET Framework | 3.5 ou superior |
| Permissão | Administrador (para desligar) |

---

## 7. Fluxo de Decisão do Usuário

```
┌────────────────────────────────────┐
│   Usuário vê a janela              │
│   com timer regressivo             │
└─────────────┬──────────────────────┘
              │
              ▼
    ┌─────────────────┐
    │ Tempo > 0?      │──── Não ────► DESLIGA AUTOMATICAMENTE
    └────────┬────────┘
             │ Sim
             ▼
    ┌─────────────────────────┐
    │  Usuário clica "Sim"?   │
    └────────┬────────────────┘
             │
       ┌─────┴─────┐
       │           │
      Sim         Não/Cancelar
       │           │
       ▼           ▼
┌──────────┐  ┌────────────────┐
│ DESLIGA  │  │ FECHA JANELA   │
│ AGORA    │  │ (FIM DO SCRIPT)│
└──────────┘  └────────────────┘
```

---

## 8. Histórico de Versões

| Versão | Data | Descrição |
|--------|------|-----------|
| 1.0 | 25/04/2026 | Versão inicial com interface GUI |

---

## 9. Contato e Suporte

Para dúvidas ou problemas com este script:
1. Consultar a seção de Troubleshooting (seção 4.5)
2. Verificar os requisitos do sistema (seção 6)
3. Revisar as variáveis configuráveis no início do código

---

*Documento gerado em: 25/04/2026*
*Autor: Documentação Técnica - Desligar.ps1*