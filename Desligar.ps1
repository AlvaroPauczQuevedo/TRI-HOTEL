Add-Type -AssemblyName System.Windows.Forms

$tempoTotal = 120
$tempoRestante = $tempoTotal

# Criar formulário simples
$form = New-Object System.Windows.Forms.Form
$form.Text = "Desligar Computador"
$form.Size = New-Object System.Drawing.Size(600, 370)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
$form.FormBorderStyle = "FixedDialog"
$form.ControlBox = $false

# Título
$titulo = New-Object System.Windows.Forms.Label
$titulo.Text = "Desligar Computador"
$titulo.Font = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$titulo.ForeColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$titulo.Location = New-Object System.Drawing.Point(40, 32)
$titulo.AutoSize = $true
$form.Controls.Add($titulo)

# Ícone de aviso
$iconLabel = New-Object System.Windows.Forms.Label
$iconLabel.Text = [char]0x26A0  # ⚠
$iconLabel.Font = New-Object System.Drawing.Font("Segoe UI Emoji", 28)
$iconLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 193, 7)
$iconLabel.Location = New-Object System.Drawing.Point(510, 18)
$iconLabel.AutoSize = $true
$form.Controls.Add($iconLabel)

# Mensagem
$mensagem = New-Object System.Windows.Forms.Label
$mensagem.Text = "Deseja desligar o computador agora?"
$mensagem.Font = New-Object System.Drawing.Font("Segoe UI", 14)
$mensagem.ForeColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
$mensagem.Location = New-Object System.Drawing.Point(40, 80)
$mensagem.AutoSize = $true
$form.Controls.Add($mensagem)

# Timer
$timerLabel = New-Object System.Windows.Forms.Label
$timerLabel.Text = "02:00"
$timerLabel.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$timerLabel.ForeColor = [System.Drawing.Color]::FromArgb(200, 0, 0)
$timerLabel.Location = New-Object System.Drawing.Point(250, 130)
$timerLabel.AutoSize = $true
$form.Controls.Add($timerLabel)

# Barra de progresso estilizada
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(100, 190)
$progressBar.Size = New-Object System.Drawing.Size(400, 25)
$progressBar.Style = "Continuous"
$form.Controls.Add($progressBar)

# Botão Sim
$btnSim = New-Object System.Windows.Forms.Button
$btnSim.Text = "Sim"
$btnSim.Size = New-Object System.Drawing.Size(130, 44)
$btnSim.Location = New-Object System.Drawing.Point(170, 240)
$btnSim.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$btnSim.ForeColor = "White"
$btnSim.FlatStyle = "Flat"
$btnSim.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$btnSim.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$btnSim.FlatAppearance.BorderSize = 0
$btnSim.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnSim.Add_Click({
    shutdown /s /t 0
})
$form.Controls.Add($btnSim)

# Botão Cance
$btnNao = New-Object System.Windows.Forms.Button
$btnNao.Text = "Cancelar"
$btnNao.Size = New-Object System.Drawing.Size(130, 44)
$btnNao.Location = New-Object System.Drawing.Point(320, 240)
$btnNao.BackColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
$btnNao.ForeColor = "Black"
$btnNao.FlatStyle = "Flat"
$btnNao.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$btnNao.BackColor = [System.Drawing.Color]::FromArgb(220, 220, 220)
$btnNao.FlatAppearance.BorderSize = 0
$btnNao.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnNao.Add_Click({
    $form.Close()
})
$form.Controls.Add($btnNao)

# Dica de segurança
$dica = New-Object System.Windows.Forms.Label
$dica.Text = "O computador vai ser desligado automaticamente."
$dica.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Italic)
$dica.ForeColor = [System.Drawing.Color]::FromArgb(120, 120, 120)
$dica.Location = New-Object System.Drawing.Point(165, 310)
$dica.MaximumSize = New-Object System.Drawing.Size(520, 0)
$dica.AutoSize = $true
$form.Controls.Add($dica)

# Timer para contagem regressiva
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000

$timer.Add_Tick({
    $script:tempoRestante--
    
    if ($script:tempoRestante -le 0) {
        $timer.Stop()
        shutdown /s /t 0
    }
    
    # Atualizar timer
    $minutos = [math]::Floor($script:tempoRestante / 60)
    $segundos = $script:tempoRestante % 60
    $minutosStr = $minutos.ToString("00")
    $segundosStr = $segundos.ToString("00")
    $timerLabel.Text = "$minutosStr`:$segundosStr"
    
    # Atualizar barra
    $porcentagem = [math]::Round(($script:tempoRestante / $script:tempoTotal) * 100)
    $progressBar.Value = $porcentagem
    
    # Mudar cor quando está perto do fim
    if ($script:tempoRestante -le 10) {
        $timerLabel.ForeColor = [System.Drawing.Color]::FromArgb(200, 0, 0)
    } elseif ($script:tempoRestante -le 30) {
        $timerLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 140, 0)
    }
})

$timer.Start()
$progressBar.Value = 100

# Fechar com Escape
$form.Add_KeyDown({
    param($sender, $e)
    if ($e.KeyCode -eq "Escape") {
        $form.Close()
    }
})

$form.ShowDialog()